class CreateJwtBlacklists < ActiveRecord::Migration[8.0]
  def change
    create_table :jwt_blacklists do |t|
      t.string :jti
      t.datetime :exp

      t.timestamps
    end
    add_index :jwt_blacklists, :jti
  end
end
