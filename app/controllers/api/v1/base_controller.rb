module Api
  module V1
    class BaseController < ActionController::API
      include JwtAuthenticatable
      include ErrorHandler

      # GET /api/v1/me
      def me
        render json: {
          id: current_user.id,
          email: current_user.email
        }
      end
    end
  end
end
