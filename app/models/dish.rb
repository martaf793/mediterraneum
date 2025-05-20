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
end
