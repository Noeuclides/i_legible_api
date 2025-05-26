module AuthHelpers
    def auth_headers_for(user)
      post '/api/v1/login', params: {
        user: {
          email: user.email,
          password: 'password123'
        }
      }

      token = response.headers['Authorization']
      { 'Authorization' => token }
    end
end
