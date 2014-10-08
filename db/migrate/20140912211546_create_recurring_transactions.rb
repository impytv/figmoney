class CreateRecurringTransactions < ActiveRecord::Migration
  def change
    create_table :recurring_transactions do |t|
      t.integer :user_id
      t.integer :recurrence_id
      t.string :description
      t.date :date_from
      t.date :date_to
      t.decimal :amount
      t.string :recurrence_code
      t.integer :last_iteration

      t.timestamps
    end
  end
end
