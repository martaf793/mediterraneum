# == Schema Information
#
# Table name: dish_food_groups
#
#  id                  :bigint           not null, primary key
#  number_of_instances :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  dish_id             :integer
#  food_group_id       :integer
#
class DishFoodGroup < ApplicationRecord
#direct associations
  belongs_to :dish, required: true, class_name: "Dish", foreign_key: "dish_id"
  belongs_to :food_group, required: true, class_name: "FoodGroup", foreign_key: "food_group_id"
  
  def self.ransackable_attributes(auth_object=nil)
    ["food_group_id", "id","number_of_instances"]
  end 
    def self.ransackable_associations(auth_object = nil)
    return ["dish", "food_group"]
  end
end
