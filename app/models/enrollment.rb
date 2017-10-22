class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :section

  #a studnet cannot enroll in the same course twice
  validates :student, uniqueness: { scope: :section }

end
