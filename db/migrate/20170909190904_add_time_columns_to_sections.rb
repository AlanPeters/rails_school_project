class AddTimeColumnsToSections < ActiveRecord::Migration[5.1]
  def change
    add_column :sections, :time, :time
    add_column :sections, :semester, :string
  end
end
