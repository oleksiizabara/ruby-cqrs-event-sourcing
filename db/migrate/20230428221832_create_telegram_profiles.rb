class CreateTelegramProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :telegram_profiles do |t|
      t.string :telegram_id, null: false, index: { unique: true }
      t.references :user, null: false, foreign_key: true, index: true
      t.string :chat_id, null: false, index: { unique: true }
      t.string :nickname, null: false, unique: true

      t.timestamps
    end
  end
end
