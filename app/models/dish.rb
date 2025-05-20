# == Schema Information
#
# Table name: dishes
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :integer
#
class Dish < ApplicationRecord
#direct associations
  has_many  :dish_food_groups, class_name: "DishFoodGroup", foreign_key: "dish_id", dependent: :destroy
  has_many  :assigned_meals, class_name: "AssignedMeal", foreign_key: "dish_id", dependent: :destroy
  belongs_to :creator, required: true, class_name: "User", foreign_key: "creator_id"
end
