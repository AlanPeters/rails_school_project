class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.string :name
      t.boolean :status
      t.integer :idnumber

      t.timestamps
    end
    add_index :students, :idnumber, unique: true
  end
end
