class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :jobs
  has_many :projects
<<<<<<< HEAD
=======
  has_many :selection_senders, class_name: 'Selection', foreign_key: 'sender_id'
  has_many :selection_receivers, class_name: 'Selection', foreign_key: 'receiver_id'
  # has_many :selections, class_name: 'Selection', foreign_key: 'receiver_id'
>>>>>>> 68ee3c445b3fc899f901089fceedfd29abf4d91f

  acts_as_taggable_on :hobbies, :personalities, :values, :soft_skills, :expertise, :languages

  def selections
    (selection_senders + selection_receivers).uniq
  end

  def self.remaining
    # à tester avec de la data
    includes(:selection_senders).where(selection_senders: {id: nil})
  end

  def liked_users
    User.where(id: Selection.pending.where(sender_id: id).pluck(:receiver_id))
  end

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
