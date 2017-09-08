class CreateSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sections do |t|
      t.belongs_to :professor, foreign_key: true
      t.belongs_to :course, foreign_key: true

      t.timestamps
    end
  end
end
