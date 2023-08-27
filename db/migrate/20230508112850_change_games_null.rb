class ChangeGamesNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :games, :start_time, true
    change_column_null :games, :end_time, true
  end
end
