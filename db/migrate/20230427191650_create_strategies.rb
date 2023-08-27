class CreateStrategies < ActiveRecord::Migration[7.0]
  def change
    create_table :strategies do |t|
      t.string :name, null: false, unique: true
      t.integer :defense_delta, null: false, default: 0
      t.integer :offense_delta, null: false, default: 0

      t.timestamps
    end
  end
end
