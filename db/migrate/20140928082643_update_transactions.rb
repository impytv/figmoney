class UpdateTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :transaction_id
    add_column :transactions, :actual, :boolean
  end
end
