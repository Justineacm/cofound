class Training < ApplicationRecord
  belongs_to :user
  belongs_to :school

  # validates :title, presence: true
  # validates :level, presence: true
  # validates :graduation_year, presence: true
end
