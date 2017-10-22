class Student < ApplicationRecord
  has_many :enrollments
  has_many :sections, through: :enrollments
  has_many :courses, through: :sections
  has_many :professors, through: :sections
end

