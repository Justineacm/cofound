class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :jobs
  has_many :projects

  acts_as_taggable_on :hobbies, :personalities, :values, :soft_skills, :expertise, :languages

  acts_as_favoritable
  acts_as_favoritor

  def total_experience
    current_user_xp = 0
    self.jobs.each do |job|
      current_user_xp += job.year_experience
    end
    return current_user_xp
  end
end
