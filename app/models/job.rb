class Job < ApplicationRecord
  belongs_to :user
  belongs_to :company

  validates :jobs, :title, presence: true
  validates :jobs, :city, presence: true
  validates :jobs, :start_date, presence: true
  validates :jobs, :end_date, presence: true
end
