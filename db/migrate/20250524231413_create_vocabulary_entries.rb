class CreateVocabularyEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :vocabulary_entries do |t|
      t.references :lesson, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :word
      t.string :translation
      t.string :context
      t.references :word_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
