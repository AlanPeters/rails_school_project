class Professor < ApplicationRecord
  has_many :sections
  has_many :courses, through: :sections

  validates :name, :department,  presence: true
  validates :name, length: { minimum: 3 }
  validates :department, length: { minimum: 3 }

  validates :department, format: { with: /\A[a-z A-Z]+\z/ }

  #only one professor with the same name in the department
  validates :name, uniqueness: { scope: :department }
end
