class Job < ApplicationRecord
  belongs_to :user
  belongs_to :company

  validates :title, presence: true
  # validates :city, presence: true
  # validates :start_date, presence: true
  # validates :end_date, presence: true
end
