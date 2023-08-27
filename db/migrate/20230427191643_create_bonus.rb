class CreateBonus < ActiveRecord::Migration[7.0]
  def change
    create_table :bonuses do |t|
      t.string :name, null: false, unique: true
      t.string :description, null: false
      t.string :affected_team, null: false, default: 'my_team'
      t.integer :duration, null: false, default: 3
      t.integer :defense_delta, null: false, default: 0
      t.integer :offense_delta, null: false, default: 0
      t.integer :speed_delta, null: false, default: 0
      t.integer :stamina_delta, null: false, default: 0
      t.integer :health_delta, null: false, default: 0
      t.integer :morale_delta, null: false, default: 0

      t.timestamps
    end
  end
end
