class AddScheduledDateToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :scheduled_date, :date
  end
end
