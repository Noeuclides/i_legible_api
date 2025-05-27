module Api
  module V1
    class WordTypesController < BaseController
      before_action :set_word_type, only: %i[ show update destroy ]

      # GET /api/v1/word_types
      def index
        @word_types = WordType.all

        render json: @word_types
      end

      # GET /api/v1/word_types/1
      def show
        render json: @word_type
      end

      # POST /api/v1/word_types
      def create
        @word_type = WordType.new(word_type_params)

        if @word_type.save
          render json: @word_type, status: :created, location: @word_type
        else
          render json: @word_type.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/word_types/1
      def update
        if @word_type.update(word_type_params)
          render json: @word_type
        else
          render json: @word_type.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/word_types/1
      def destroy
        @word_type.destroy!
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_word_type
        @word_type = WordType.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def word_type_params
        params.fetch(:word_type, {})
      end
    end
  end
end
