class AddClassroomToSection < ActiveRecord::Migration[5.1]
  def change
    add_column :sections, :classroom, :string
  end
end
