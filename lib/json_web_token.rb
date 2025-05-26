class JsonWebToken
  SECRET_KEY = Rails.env.test? ? Rails.application.secret_key_base : Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    payload[:sub] = payload.delete(:user_id) if payload[:user_id]
    payload[:jti] = SecureRandom.uuid
    payload[:scp] = "user"
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  rescue JWT::DecodeError
    nil
  end
end
