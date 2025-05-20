# == Schema Information
#
# Table name: food_groups
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class FoodGroup < ApplicationRecord
#direct association
  has_many  :dish_food_groups, class_name: "DishFoodGroup", foreign_key: "food_group_id", dependent: :destroy
end
