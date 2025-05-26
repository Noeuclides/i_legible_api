require "swagger_helper"

RSpec.describe "Vocabulary Entries API", type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }
  let(:lesson) { create(:lesson, user: user) }

  path "/api/v1/vocabulary_entries" do
    get "Lists all vocabulary entries for the user" do
      tags "Vocabulary Entries"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"

      response "200", "vocabulary entries found" do
        before do
          3.times do |i|
            create(:vocabulary_entry, user: user)
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

    post "Creates a vocabulary entry" do
      tags "Vocabulary Entries"
      consumes "application/json"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"
      parameter name: :vocabulary_entry, in: :body, schema: {
        type: :object,
        properties: {
          vocabulary_entry: {
            type: :object,
            properties: {
              word: { type: :string, example: "New Word" },
              translation: { type: :string, example: "Word translation" },
              context: { type: :string, example: "Usage context" },
              word_type_id: { type: :integer, example: 1 }
            },
            required: %w[word translation word_type_id]
          }
        }
      }

      response "201", "vocabulary entry created" do
        let(:word_type) { create(:word_type, name: "noun") }
        let(:vocabulary_entry) do
          {
            vocabulary_entry: {
              word: "Test Word",
              translation: "Test Translation",
              context: "Test Context",
              word_type_id: word_type.id
            }
          }
        end

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["word"]).to eq("Test Word")
        end
      end

      response "422", "invalid request" do
        let(:vocabulary_entry) { { vocabulary_entry: { word: "" } } }
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid_token" }
        let(:vocabulary_entry) { { vocabulary_entry: { word: "Test" } } }
        run_test!
      end
    end
  end

  path "/api/v1/lessons/{lesson_id}/vocabulary_entries" do
    parameter name: :lesson_id, in: :path, type: :string

    let(:lesson_id) { lesson.id }

    get "Lists all vocabulary entries for a lesson" do
      tags "Vocabulary Entries"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"

      response "200", "vocabulary entries found" do
        before do
          3.times do |i|
            create(:vocabulary_entry, lesson: lesson, user: user)
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

      response "404", "lesson not found" do
        let(:lesson_id) { "invalid" }
        run_test!
      end
    end

    post "Creates a vocabulary entry for a lesson" do
      tags "Vocabulary Entries"
      consumes "application/json"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"
      parameter name: :vocabulary_entry, in: :body, schema: {
        type: :object,
        properties: {
          vocabulary_entry: {
            type: :object,
            properties: {
              word: { type: :string, example: "New Word" },
              translation: { type: :string, example: "Word translation" },
              context: { type: :string, example: "Usage context" },
              word_type_id: { type: :integer, example: 1 }
            },
            required: %w[word translation word_type_id]
          }
        }
      }

      response "201", "vocabulary entry created" do
        let(:word_type) { create(:word_type, name: "noun") }
        let(:vocabulary_entry) do
          {
            vocabulary_entry: {
              word: "Test Word",
              translation: "Test Translation",
              context: "Test Context",
              word_type_id: word_type.id
            }
          }
        end

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["word"]).to eq("Test Word")
          expect(json["lesson_id"]).to eq(lesson.id)
        end
      end

      response "422", "invalid request" do
        let(:vocabulary_entry) { { vocabulary_entry: { word: "" } } }
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid_token" }
        let(:vocabulary_entry) { { vocabulary_entry: { word: "Test" } } }
        run_test!
      end

      response "404", "lesson not found" do
        let(:lesson_id) { "invalid" }
        let(:vocabulary_entry) { { vocabulary_entry: { word: "Test" } } }
        run_test!
      end
    end
  end

  path "/api/v1/vocabulary_entries/{id}" do
    parameter name: :id, in: :path, type: :string

    let(:existing_entry) do
      create(:vocabulary_entry, user: user)
    end
    let(:id) { existing_entry.id }

    get "Retrieves a vocabulary entry" do
      tags "Vocabulary Entries"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"

      response "200", "vocabulary entry found" do
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["word"]).to eq(existing_entry.word)
        end
      end

      response "404", "vocabulary entry not found" do
        let(:id) { "invalid" }
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid_token" }
        run_test!
      end
    end

    put "Updates a vocabulary entry" do
      tags "Vocabulary Entries"
      consumes "application/json"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"
      parameter name: :vocabulary_entry, in: :body, schema: {
        type: :object,
        properties: {
          vocabulary_entry: {
            type: :object,
            properties: {
              word: { type: :string, example: "Updated Word" },
              translation: { type: :string, example: "Updated translation" },
              context: { type: :string, example: "Updated context" }
            }
          }
        }
      }

      response "200", "vocabulary entry updated" do
        let(:vocabulary_entry) do
          {
            vocabulary_entry: {
              word: "Updated Word",
              translation: "Updated Translation",
              context: "Updated Context"
            }
          }
        end

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json["word"]).to eq("Updated Word")
        end
      end

      response "404", "vocabulary entry not found" do
        let(:id) { "invalid" }
        let(:vocabulary_entry) { { vocabulary_entry: { word: "Test" } } }
        run_test!
      end

      response "422", "invalid request" do
        let(:vocabulary_entry) { { vocabulary_entry: { word: "" } } }
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid_token" }
        let(:vocabulary_entry) { { vocabulary_entry: { word: "Test" } } }
        run_test!
      end
    end

    delete "Deletes a vocabulary entry" do
      tags "Vocabulary Entries"
      produces "application/json"
      security [ bearerAuth: [] ]

      parameter name: "Authorization", in: :header, type: :string, required: true,
                description: "JWT token in the format: Bearer <token>"

      response "204", "vocabulary entry deleted" do
        run_test!
      end

      response "404", "vocabulary entry not found" do
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
