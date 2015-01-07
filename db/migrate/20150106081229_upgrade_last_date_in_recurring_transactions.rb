class UpgradeLastDateInRecurringTransactions < ActiveRecord::Migration
  def up
    last_iteration_update = "UPDATE recurring_transactions r
                                  SET last_date = t.date
                                 FROM (SELECT date, recurrence_id, iteration
                                         FROM transactions WHERE committed = true) t
                                WHERE t.recurrence_id = r.id
                                  AND t.iteration = r.last_iteration "

      Transaction.connection.execute(last_iteration_update)
  end
end
