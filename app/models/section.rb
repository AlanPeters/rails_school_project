class Section < ApplicationRecord
  belongs_to :professor
  belongs_to :course
  validates :time, :presence => true
  validates :semester, :presence => true
end

