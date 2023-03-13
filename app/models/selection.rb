class Selection < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages, dependent: :destroy

  enum :status, {
    suggestion: 0,
    pending: 1,
    accepted: 2,
    rejected: 3
  }
end
