class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.string :department

      t.timestamps
    end
  end
end
