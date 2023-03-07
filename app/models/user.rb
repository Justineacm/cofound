class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  acts_as_taggable_on :hobbies, :personalities, :values, :soft_skills, :hard_skills, :languages

  acts_as_favoritable
  acts_as_favoritor
end
