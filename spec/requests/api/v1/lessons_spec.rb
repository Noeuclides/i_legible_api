require "swagger_helper"

RSpec.describe "Lessons API", type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }

  path "/api/v1/lessons" do
    get "Lists all lessons" do
      tags "Lessons"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"

      response "200", "lessons found" do
        before do
          3.times do |i|
            create(:lesson, user: user)
          end
        end

        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(3)
        end
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid_token" }
        run_test!
      end
    end

    post "Creates a lesson" do
      tags "Lessons"
      consumes "application/json"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"
      parameter name: :lesson, in: :body, schema: {
        type: :object,
        properties: {
          lesson: {
            type: :object,
            properties: {
              title: { type: :string, example: "My New Lesson" },
              summary: { type: :string, example: "A detailed summary" },
              taken_on: { type: :string, example: Date.today.to_s }
            },
            required: %w[title summary taken_on]
          }
        }
      }

      response "201", "lesson created" do
        let(:lesson) do
          {
            lesson: {
              title: "Test Lesson",
              summary: "Test Summary",
              taken_on: Date.today.to_s
            }
          }
        end

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["title"]).to eq("Test Lesson")
        end
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid_token" }
        let(:lesson) { { lesson: { title: "Test" } } }
        run_test!
      end
    end
  end

  path "/api/v1/lessons/{id}" do
    parameter name: :id, in: :path, type: :string

    let(:existing_lesson) do
      create(:lesson, user: user)
    end
    let(:id) { existing_lesson.id }

    get "Retrieves a lesson" do
      tags "Lessons"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"

      response "200", "lesson found" do
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["title"]).to eq(existing_lesson.title)
        end
      end

      response "404", "lesson not found" do
        let(:id) { "invalid" }
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid_token" }
        run_test!
      end
    end

    put "Updates a lesson" do
      tags "Lessons"
      consumes "application/json"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"
      parameter name: :lesson, in: :body, schema: {
        type: :object,
        properties: {
          lesson: {
            type: :object,
            properties: {
              title: { type: :string, example: "Updated Lesson" },
              summary: { type: :string, example: "Updated summary" },
              taken_on: { type: :string, example: Date.today.to_s }
            }
          }
        }
      }

      response "200", "lesson updated" do
        let(:lesson) do
          {
            lesson: {
              title: "Updated Title",
              summary: "Updated Summary",
              taken_on: Date.today.to_s
            }
          }
        end

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["title"]).to eq("Updated Title")
        end
      end

      response "404", "lesson not found" do
        let(:id) { "invalid" }
        let(:lesson) { { lesson: { title: "Test" } } }
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid_token" }
        let(:lesson) { { lesson: { title: "Test" } } }
        run_test!
      end
    end

    delete "Deletes a lesson" do
      tags "Lessons"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"

      response "204", "lesson deleted" do
        run_test!
      end

      response "404", "lesson not found" do
        let(:id) { "invalid" }
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid_token" }
        run_test!
      end
    end
  end
end
