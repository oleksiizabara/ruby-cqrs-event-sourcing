class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.references :room, null: false, foreign_key: true, index: true
      t.references :home_team, null: false, foreign_key: { to_table: :teams }, index: true
      t.references :guest_team, foreign_key: { to_table: :teams }, index: true
      t.references :game_type, null: false, foreign_key: true, index: true
      t.integer :home_team_score, null: false, default: 0
      t.integer :away_team_score, null: false, default: 0
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end
  end
end
