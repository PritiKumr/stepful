class CreateSlots < ActiveRecord::Migration[7.2]
  def change
    create_table :slots do |t|
      t.integer :coach_id
      t.integer :student_id
      t.datetime :start_time
      t.integer :satisfaction_score
      t.text :notes

      t.timestamps
    end
  end
end
