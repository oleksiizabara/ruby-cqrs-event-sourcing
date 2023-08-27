class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.references :team, null: false, foreign_key: true, index: true
      t.references :game_type, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.integer :number, null: false
      t.string :position, null: false
      t.string :sub_position, null: false
      t.integer :defense, null: false, default: 20
      t.integer :offense, null: false, default: 20
      t.integer :speed, null: false, default: 20
      t.integer :stamina, null: false, default: 20
      t.integer :health, null: false, default: 100
      t.integer :morale, null: false, default: 20

      t.timestamps
    end
  end
end
