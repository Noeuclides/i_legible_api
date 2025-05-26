module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      include JwtAuthenticatable
      respond_to :json
      skip_before_action :authenticate_user_from_token!, only: [:create]

      def create
        build_resource(sign_up_params)

        if resource.save
          sign_in(resource)
          token = request.env["warden-jwt_auth.token"]
          response.headers["Authorization"] = "Bearer #{token}"
          render json: {
            message: "Signed up successfully.",
            user: {
              id: resource.id,
              email: resource.email
            },
            token: token
          }, status: :created
        else
          render json: {
            message: "Sign up failed.",
            errors: resource.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end 