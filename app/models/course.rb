class Course < ApplicationRecord
  has_many :sections
  has_many :professors, through: :sections
end
