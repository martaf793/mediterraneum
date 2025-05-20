class CreateDishFoodGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :dish_food_groups do |t|
      t.integer :dish_id
      t.integer :food_group_id
      t.integer :number_of_instances

      t.timestamps
    end
  end
end
