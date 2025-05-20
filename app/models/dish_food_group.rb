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
end
