class Professor < ApplicationRecord
  has_many :sections
  has_many :courses, through: :sections
end
