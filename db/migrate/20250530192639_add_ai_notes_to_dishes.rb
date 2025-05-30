class AddAiNotesToDishes < ActiveRecord::Migration[7.1]
  def change
    add_column :dishes, :ai_notes, :text
  end
end
