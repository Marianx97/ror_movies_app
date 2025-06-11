class Auth::AuthController < ActionController::Base
  rescue_from ActionController::ParameterMissing, with: :bad_request

  skip_forgery_protection

  # POST /auth/register
  def register
    user = User.new(register_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { access_token: token, user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /auth/login
  def login
    if login_params[:email].blank? || login_params[:password].blank?
      return render json: { errors: [ "Email and password must be provided" ] }, status: :bad_request
    end

    user = User.find_by(email: login_params[:email])

    if user&.authenticate(login_params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { access_token: token, user: user }, status: :ok
    else
      render json: { errors: [ "Invalid email or password" ] }, status: :unauthorized
    end
  end

  private

  def register_params
    params.require(:auth).permit(:username, :email, :password, :password_confirmation)
  end

  def login_params
    params.require(:auth).permit(:email, :password)
  end

  def bad_request
    render json: { message: "Bad Request" }, status: :bad_request
  end
end
