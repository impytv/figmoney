class AddLastDateToRecurringTransactions < ActiveRecord::Migration
  def change
    add_column :recurring_transactions, :last_date, :date
  end
end
