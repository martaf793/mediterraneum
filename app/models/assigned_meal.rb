# == Schema Information
#
# Table name: assigned_meals
#
#  id          :bigint           not null, primary key
#  assigned_to :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  dish_id     :integer
#  user_id     :integer
#
class AssignedMeal < ApplicationRecord
#direct associations
  belongs_to :dish, required: true, class_name: "Dish", foreign_key: "dish_id"
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
end
