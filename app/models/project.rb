class Project < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :industry, presence: true
  validates :city, presence: true
end
