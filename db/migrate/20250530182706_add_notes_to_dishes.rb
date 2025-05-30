class AddNotesToDishes < ActiveRecord::Migration[7.1]
  def change
    add_column :dishes, :notes, :text
  end
end
