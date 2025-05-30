# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates(:email, {
    :presence => true,
    :uniqueness => { :case_sensitive => false },
  })
  #direct associations
  has_many  :dishes, class_name: "Dish", foreign_key: "creator_id", dependent: :destroy
  has_many  :assigned_meals, class_name: "AssignedMeal", foreign_key: "user_id", dependent: :destroy
  has_many :eaten_dishes, through: :assigned_meals, source: :dish

end
