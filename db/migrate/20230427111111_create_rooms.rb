class CreateRooms < ActiveRecord::Migration[7.0]
  def up
    create_table :rooms do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.boolean :private, null: false, default: false
      t.string :encrypted_password, null: true

      t.timestamps
    end
  end

  def down
    drop_table :rooms, force: :cascade
  end
end
