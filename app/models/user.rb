class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :jobs

  acts_as_taggable_on :hobbies, :personalities, :values, :soft_skills, :hard_skills, :languages
end
