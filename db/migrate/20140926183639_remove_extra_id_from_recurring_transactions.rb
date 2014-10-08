class RemoveExtraIdFromRecurringTransactions < ActiveRecord::Migration
  def change
    remove_column :recurring_transactions, :recurrence_id
  end
end
