class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :game_type, null: false, foreign_key: true, index: true
      t.string :name, null: false, unique: true
      t.boolean :completed, null: false, default: false
      t.integer :wins_count, null: false, default: 0
      t.integer :losses_count, null: false, default: 0
      t.integer :draws_count, null: false, default: 0
      t.integer :points_scored, null: false, default: 0
      t.integer :points_conceded, null: false, default: 0

      t.timestamps
    end
  end
end
