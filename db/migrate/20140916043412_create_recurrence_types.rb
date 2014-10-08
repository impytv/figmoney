class CreateRecurrenceTypes < ActiveRecord::Migration
  def change
    create_table :recurrence_types do |t|
      t.string :recurrence_code
      t.string :description
      t.string :interval_type
      t.integer :interval_length

      t.timestamps
    end
  end
end
