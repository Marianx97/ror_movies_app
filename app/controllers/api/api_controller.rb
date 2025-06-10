module Api
  class ApiController < ActionController::Base
    rescue_from ActionController::UnknownFormat, with: :not_supported_format
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

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
  end
end
