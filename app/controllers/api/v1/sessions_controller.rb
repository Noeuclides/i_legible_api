# app/controllers/api/v1/sessions_controller.rb
module Api
  module V1
    class SessionsController < Devise::SessionsController
      include JwtAuthenticatable
      respond_to :json
      skip_before_action :verify_signed_out_user
      skip_before_action :authenticate_user_from_token!, only: [ :create ]
      wrap_parameters format: []

      def create
        auth_params = params[:user] || params
        user = User.find_by(email: auth_params[:email])
        if user&.valid_password?(auth_params[:password])
          sign_in(user)
          token = request.env["warden-jwt_auth.token"]
          response.headers["Authorization"] = "Bearer #{token}"
          render json: { 
            message: "Logged in successfully.",
            token: token
          }, status: :ok
        else
          render json: { error: "Invalid email or password." }, status: :unauthorized
        end
      end

      def destroy
        if current_user
          sign_out(current_user)
          render json: { message: "Logged out successfully." }, status: :ok
        else
          render json: { message: "Couldn't find an active session." }, status: :unauthorized
        end
      end

      private

      def verify_signed_out_user
        # Override devise's method to allow logout without session
      end
    end
  end
end
