class CreateFoodGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :food_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
