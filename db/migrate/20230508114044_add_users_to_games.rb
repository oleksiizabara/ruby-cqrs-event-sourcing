class AddUsersToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :home_user_id, :integer, null: false
    add_column :games, :guest_user_id, :integer
  end
end
