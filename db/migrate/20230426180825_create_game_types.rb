class CreateGameTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :game_types do |t|
      t.string :identifier, null: false, index: true, unique: true
      t.references :user, null: false, foreign_key: true, index: true
      t.jsonb :game_data, default: {}
      t.jsonb :approved, default: false

      t.timestamps
    end
  end
end
