class CreateGameRecaps < ActiveRecord::Migration[7.0]
  def change
    create_table :game_recaps do |t|
      t.references :game, null: false, foreign_key: true, index: true
      t.text :recap

      t.timestamps
    end
  end
end
