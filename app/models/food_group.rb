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
  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["dish_food_groups"]
  end
  #direct association
  has_many  :dish_food_groups, class_name: "DishFoodGroup", foreign_key: "food_group_id", dependent: :destroy
  has_many :dishes, through: :dish_food_groups

end
