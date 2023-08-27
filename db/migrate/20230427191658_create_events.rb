class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :room, null: false, foreign_key: true, index: true
      t.references :team, foreign_key: true, index: true
      t.string :event_type, null: false, index: true
      t.jsonb :data, null: false, default: {}

      t.timestamps
    end
  end
end
