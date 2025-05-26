class CreateLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :lessons do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :summary
      t.date :taken_on

      t.timestamps
    end
  end
end
