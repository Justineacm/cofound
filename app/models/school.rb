class School < ApplicationRecord
  belongs_to :training

  validates :schools, :name, presence: true
  validates :schools, :city, presence: true
end
