class CreateResourceItems < ActiveRecord::Migration[8.0]
  def change
    create_table :resource_items do |t|
      t.references :attachable, polymorphic: true, null: false
      t.string :url

      t.timestamps
    end
  end
end
