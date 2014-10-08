class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :transaction_id
      t.date :date
      t.string :description
      t.decimal :delta
      t.decimal :amount
      t.integer :recurrence_id
      t.integer :iteration
      t.boolean :committed
      t.boolean :overridden_amount

      t.timestamps
    end
  end
end
