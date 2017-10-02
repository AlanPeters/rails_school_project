class Section < ApplicationRecord
  belongs_to :professor
  belongs_to :course
  validates :time, presence: true
  validates :semester, presence: true
  validates :semester, presence: true
  #a professor cannot teach two classes at the same time
  validates :professor, uniqueness: { scope: [:time, :semester] }

  #the class cannot be taught in the same classroom at the same time 
  validates :classroom, uniqueness: { scope: [:time, :semester] }
end

