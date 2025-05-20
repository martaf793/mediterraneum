class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates(:username, {
    :presence => true,
    :uniqueness => { :case_sensitive => false },
  })
  #direct associations
  has_many  :dishes, class_name: "Dish", foreign_key: "creator_id", dependent: :destroy
  has_many  :assigned_meals, class_name: "AssignedMeal", foreign_key: "user_id", dependent: :destroy
end
