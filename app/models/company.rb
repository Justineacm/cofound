class Company < ApplicationRecord
  has_many :jobs

  validates :industry, presence: true
end
