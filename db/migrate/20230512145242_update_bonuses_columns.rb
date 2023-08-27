class UpdateBonusesColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :bonuses, :affected_team, :string

    add_column :bonuses, :affect_home_team, :boolean, null: false, default: true
  end
end
