module JwtAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user_from_token!
  end

  private

  def authenticate_user_from_token!
    unless auth_token
      render json: { error: "Unauthorized" }, status: :unauthorized and return
    end

    payload = JsonWebToken.decode(auth_token)
    if payload.present? && payload[:sub].present?
      @current_user = User.find_by(id: payload[:sub])
    end

    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def auth_token
    @auth_token ||= request.headers["Authorization"]&.split(" ")&.last
  end

  def current_user
    @current_user
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    render json: { error: "Unauthorized" }, status: :unauthorized unless user_signed_in?
  end
end
