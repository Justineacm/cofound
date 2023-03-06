class Company < ApplicationRecord
  belongs_to :job

  validates :companies, :industry, presence: true
end
