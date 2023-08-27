class AddDescriptionToStrategiews < ActiveRecord::Migration[7.0]
  def change
    add_column :strategies, :description, :text
  end
end
