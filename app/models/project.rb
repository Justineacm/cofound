class Project < ApplicationRecord
  belongs_to :user

  validates :projects, :name, presence: true
  validates :projects, :industry, presence: true
  validates :projects, :city, presence: true
end
