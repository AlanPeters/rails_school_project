class CreateEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :enrollments do |t|
      t.datetime :enrolledDate
      t.references :student, foreign_key: true
      t.references :section, foreign_key: true

      t.timestamps
    end
  end
end
