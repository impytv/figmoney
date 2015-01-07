class UpdateScheduledDateInTransactions < ActiveRecord::Migration
  def up
    scheduled_date_update = "UPDATE transactions
                                SET scheduled_date = date"

      Transaction.connection.execute(scheduled_date_update)
  end
end
