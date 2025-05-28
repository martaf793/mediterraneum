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
  def self.ransackable_attributes(auth_object=nil)
    ["name"]
  end 
  def self.ransackable_associations(auth_object = nil)
    ["dish_food_groups", "food_groups"]
  end

#direct associations
  has_many  :dish_food_groups, class_name: "DishFoodGroup", foreign_key: "dish_id", dependent: :destroy
  has_many  :assigned_meals, class_name: "AssignedMeal", foreign_key: "dish_id", dependent: :destroy
  belongs_to :creator, required: true, class_name: "User", foreign_key: "creator_id"
  has_many :food_groups, through: :dish_food_groups
  has_many :users_who_ate_it, through: :assigned_meals, source: :user
end
