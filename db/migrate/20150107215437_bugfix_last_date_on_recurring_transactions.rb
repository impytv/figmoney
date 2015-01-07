class BugfixLastDateOnRecurringTransactions < ActiveRecord::Migration
  def up
    last_date_update = "UPDATE recurring_transactions SET last_date = date_from WHERE last_date IS NULL"

    Transaction.connection.execute(last_date_update)
  end
end
