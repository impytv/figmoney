class TransactionsController < ApplicationController

  before_action :authenticate_user!

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
    params.require(:transaction).permit(:amount, :delta, :date)
  end

  def create
    @user = current_user

    ActiveRecord::Base.transaction do
      transaction = Transaction.new(balance_transaction_params)
      transaction.user_id = @user.id
      transaction.actual = true
      transaction.committed = true
      transaction.date = Date.today
      transaction.description = 'Actual balance'
      transaction.save

      commit = "UPDATE transactions SET committed = true WHERE date <= CURRENT_DATE AND user_id = #{@user.id}"
      Transaction.connection.execute(commit)

      last_iteration_update = "UPDATE recurring_transactions r
                                  SET last_iteration = t.max_iteration
                                 FROM (SELECT MAX(iteration) AS max_iteration, recurrence_id 
                                         FROM transactions WHERE user_id = #{@user.id} AND committed = true GROUP BY recurrence_id) t
                                WHERE t.recurrence_id = r.id
                                  AND r.user_id = #{@user.id} "

      Transaction.connection.execute(last_iteration_update)
    end

    redirect_to action: "index"
  end

  def balance_transaction_params
    params.require(:transaction).permit(:amount)
  end

  def index
    @user = current_user
    @transactions = Transaction.where("user_id = #{@user.id} AND (committed = false OR actual = true)").order(date: :asc, actual: :asc, delta: :desc, description: :asc)

    @transactions = process_transactions(@transactions)
  end

  def process_transactions(transactions)
    amount = 0.0
    actuals = 0
    transactions.each do |transaction|
      if transaction.actual
        amount = transaction.amount
        actuals = actuals + 1
      else
        amount = amount + transaction.delta
        transaction.amount = amount
      end
    end

    return transactions.drop(actuals - 1)
  end

end
