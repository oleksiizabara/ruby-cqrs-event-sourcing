class CreateRoomProjections < ActiveRecord::Migration[7.0]
  def change
    create_table :room_projections do |t|
      t.references :room, null: false, foreign_key: true, index: true
      t.integer :users_count, null: false, default: 0

      t.timestamps
    end
  end
end
