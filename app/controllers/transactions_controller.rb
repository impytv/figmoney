class TransactionsController < ApplicationController

  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    transaction = Transaction.find(params[:id])
    transaction.overridden_amount = true
    transaction.update(edit_transaction_params)

    redirect_to action: "index"
  end

  def edit_transaction_params
    params.require(:transaction).permit(:delta, :date)
  end

  def create
    ActiveRecord::Base.transaction do
      transaction = Transaction.new(balance_transaction_params)
      transaction.actual = true
      transaction.committed = true
      transaction.date = Date.today
      transaction.description = 'Actual balance'
      transaction.save

      commit = "UPDATE transactions SET committed = true WHERE date <= CURRENT_DATE"
      Transaction.connection.execute(commit)

      last_iteration_update = "UPDATE recurring_transactions r
                                  SET last_iteration = t.max_iteration
                                 FROM (SELECT MAX(iteration) AS max_iteration, recurrence_id FROM transactions WHERE committed = true GROUP BY recurrence_id) t
                                WHERE t.recurrence_id = r.id"

      Transaction.connection.execute(last_iteration_update)
    end

    redirect_to action: "index"
  end

  def balance_transaction_params
    params.require(:transaction).permit(:amount)
  end

  def index
    @transactions = Transaction.all.order(:date, :actual, :delta, :description)

    amount = 0.0
    @transactions.each do |transaction|
      if transaction.actual
        amount = transaction.amount
      else
        amount = amount + transaction.delta
        transaction.amount = amount
      end
    end
  end

end