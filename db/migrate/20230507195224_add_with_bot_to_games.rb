class AddWithBotToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :with_bot, :boolean, null: false, default: false
  end
end
