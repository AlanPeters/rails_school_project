class Course < ApplicationRecord
  has_many :sections
  has_many :professors, through: :sections

  has_many :enrollments
  has_many :students, through: :enrollments

  validates :name, :description, :department, presence: true
  validates :name, length: { minumum: 4 }
  validates :department, length: {minimum: 3} 
  validates :description, length: {minimum: 15}

  validates :department, format: { with: /\A[a-z A-Z]+\z/ }

end
