class CreateShifts < ActiveRecord::Migration[5.2]
  def change
    create_table :shifts do |t|
      t.date :date
      t.time :start_time
      t.time :end_time
      t.string :notes
      t.references :assignment, foreign_key: true

      t.timestamps
    end
  end
end
