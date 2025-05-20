class AssignedMeal < ApplicationRecord
#direct associations
  belongs_to :dish, required: true, class_name: "Dish", foreign_key: "dish_id"
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
end
