class Api::ApiController < ActionController::Base
  rescue_from ActionController::UnknownFormat, with: :not_supported_format
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  attr_reader :current_user

  skip_forgery_protection

  def render_unprocessable_entity(error)
    render json: { message: error.record.errors.full_messages.to_sentence },
            status: :unprocessable_entity
  end

  def render_not_found(error)
    render json: { message: "Resource not found" }, status: :not_found
  end

  def not_supported_format
    raise ActionController::RoutingError.new("Not supported format")
  end

  private

  def authorize_request
    header = request.headers["Authorization"]
    if header
      token = header.split(" ").last
      decoded = JsonWebToken.decode(token)
      @current_user = User.find(decoded[:user_id]) if decoded
    else
      raise ActiveRecord::RecordNotFound
    end
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { errors: [ "Unauthorized" ] }, status: :unauthorized
  end

  def authorize_admin!
    unless current_user&.isAdmin
      render json: { errors: [ "Forbidden: Admin access required" ] }, status: :forbidden
    end
  end
end
