require "swagger_helper"

RSpec.describe "Authentication API", type: :request do
  path "/api/v1/signup" do
    post "Creates a new user account" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: "user@example.com" },
              password: { type: :string, example: "password123" },
              password_confirmation: { type: :string, example: "password123" }
            },
            required: %w[email password password_confirmation]
          }
        }
      }

      response "201", "user created successfully" do
        let(:user) { { user: { email: "test@example.com", password: "password123", password_confirmation: "password123" } } }

        run_test! do |response|
          expect(response.headers["Authorization"]).to be_present
          json = JSON.parse(response.body)
          expect(json["message"]).to eq("Signed up successfully.")
          expect(json["user"]["email"]).to eq("test@example.com")
          expect(json["token"]).to be_present
        end
      end

      response "422", "invalid request" do
        let(:user) { { user: { email: "invalid_email", password: "short", password_confirmation: "not_matching" } } }

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["message"]).to eq("Sign up failed.")
          expect(json["errors"]).to be_present
        end
      end
    end
  end

  path "/api/v1/login" do
    post "Authenticates user and returns JWT token" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: "user@example.com" },
              password: { type: :string, example: "password123" }
            },
            required: %w[email password]
          }
        }
      }

      response "200", "user logged in successfully" do
        let(:test_user) { create(:user, email: "test@example.com", password: "password123") }
        let(:user) { { user: { email: test_user.email, password: "password123" } } }

        run_test! do |response|
          expect(response.headers["Authorization"]).to be_present
          expect(JSON.parse(response.body)["message"]).to eq("Logged in successfully.")
        end
      end

      response "401", "invalid credentials" do
        let(:user) { { user: { email: "test@example.com", password: "wrong_password" } } }

        run_test! do |response|
          expect(response.headers["Authorization"]).to be_nil
          expect(JSON.parse(response.body)["error"]).to eq("Invalid email or password.")
        end
      end
    end
  end

  path "/api/v1/logout" do
    delete "Logs out user (revokes JWT token)" do
      tags "Authentication"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"

      response "200", "user logged out successfully" do
        let(:test_user) { create(:user) }
        let(:Authorization) do
          post "/api/v1/login", params: {
            user: {
              email: test_user.email,
              password: test_user.password
            }
          }
          response.headers["Authorization"]
        end

        run_test! do |response|
          expect(JSON.parse(response.body)["message"]).to eq("Logged out successfully.")
        end
      end

      response "401", "unauthorized" do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end
end
