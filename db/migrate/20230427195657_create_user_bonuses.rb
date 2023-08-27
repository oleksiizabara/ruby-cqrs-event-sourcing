class CreateUserBonuses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_bonuses do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :game, null: false, foreign_key: true
      t.references :bonuse, null: false, foreign_key: true
      t.boolean :used, null: false, default: false

      t.timestamps
    end
  end
end
