module Api
  module V1
    class BaseController < ActionController::API
      include JwtAuthenticatable
      include ErrorHandler
    end
  end
end
