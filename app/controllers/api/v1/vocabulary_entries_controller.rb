module Api
  module V1
    class VocabularyEntriesController < BaseController
      before_action :set_vocabulary_entry, only: %i[show update destroy]
      before_action :set_lesson, only: %i[index create], if: :lesson_id_present?

      def index
        @vocabulary_entries = if @lesson
          @lesson.vocabulary_entries
        else
          current_user.vocabulary_entries
        end

        render json: @vocabulary_entries
      end

      def show
        render json: @vocabulary_entry
      end

      def create
        @vocabulary_entry = if @lesson
          @lesson.vocabulary_entries.build(vocabulary_entry_params.merge(user: current_user))
        else
          current_user.vocabulary_entries.build(vocabulary_entry_params)
        end

        if @vocabulary_entry.save
          render json: @vocabulary_entry, status: :created
        else
          render json: @vocabulary_entry.errors, status: :unprocessable_entity
        end
      end

      def update
        if @vocabulary_entry.update(vocabulary_entry_params)
          render json: @vocabulary_entry
        else
          render json: @vocabulary_entry.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @vocabulary_entry.destroy!
        head :no_content
      end

      private

      def set_vocabulary_entry
        @vocabulary_entry = if lesson_id_present?
          current_user.lessons.find(params[:lesson_id]).vocabulary_entries.find(params[:id])
        else
          current_user.vocabulary_entries.find(params[:id])
        end
      end

      def set_lesson
        @lesson = current_user.lessons.find(params[:lesson_id])
      end

      def lesson_id_present?
        params[:lesson_id].present?
      end

      def vocabulary_entry_params
        params.require(:vocabulary_entry).permit(:word, :translation, :context, :word_type_id)
      end
    end
  end
end
