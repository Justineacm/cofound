class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :jobs
  has_many :projects


  acts_as_taggable_on :hobbies, :personalities, :values, :soft_skills, :expertise, :languages

  def total_experience
    current_user_xp = 0
    self.jobs.each do |job|
      current_user_xp += job.year_experience
    end
    return current_user_xp
  end

  def selection_for(user)
    selection_as_sender = Selection.find_by(sender_id: self.id, receiver_id: user.id)
    return selection_as_sender if selection_as_sender.present?

    Selection.find_by(sender_id: user.id, receiver_id: self.id)
  end

  def can_see_profil_infos?(user)
    selection = selection_for(user)

    selection.present? && selection.accepted?
  end
end
