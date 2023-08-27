class AddPowerToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :power, :float

    change_column :players, :defense, :float
    change_column :players, :offense, :float
    change_column :players, :speed, :float
    change_column :players, :stamina, :float
    change_column :players, :health, :float
    change_column :players, :morale, :float
  end
end
