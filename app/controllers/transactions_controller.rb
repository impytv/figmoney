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
                                  SET last_iteration = t.max_iteration,
                                      last_date = max_scheduled_date
                                 FROM (SELECT MAX(iteration) AS max_iteration, MAX(scheduled_date) AS max_scheduled_date, recurrence_id 
                                         FROM transactions WHERE user_id = #{@user.id} AND committed = true GROUP BY recurrence_id) t
                                WHERE t.recurrence_id = r.id
                                  AND r.user_id = #{@user.id} "

      Transaction.connection.execute(last_iteration_update)

      delete = "DELETE FROM transactions WHERE committed = false AND overridden_amount = false AND user_id = #{@user.id}"
      Transaction.connection.execute(delete)

      insert = "INSERT INTO transactions (description, delta, iteration, recurrence_id, date, committed, overridden_amount, user_id, actual, created_at, updated_at)
    SELECT r.description, r.amount, r.last_iteration + i.iteration, r.id, r.last_date + i.stride * interval '1 day', false, false, user_id, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM recurring_transactions r, iterations i
     WHERE r.recurrence_code = i.recurrence_code
       AND i.interval_type = 'D'
       AND r.user_id = #{@user.id}
       AND r.date_from + i.stride * interval '1 day' BETWEEN r.date_from AND r.date_to
       AND NOT EXISTS (SELECT * FROM transactions t WHERE r.id = t.recurrence_id AND t.iteration = r.last_iteration + i.iteration)
     UNION ALL
    SELECT r.description, r.amount, r.last_iteration + i.iteration, r.id, r.last_date + i.stride * interval '1 month', false, false, user_id, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM recurring_transactions r, iterations i
     WHERE r.recurrence_code = i.recurrence_code
       AND i.interval_type = 'M'
       AND r.user_id = #{@user.id}
       AND r.date_from + i.stride * interval '1 month' BETWEEN r.date_from AND r.date_to
       AND NOT EXISTS (SELECT * FROM transactions t WHERE r.id = t.recurrence_id AND t.iteration = r.last_iteration + i.iteration)"

      Transaction.connection.execute(insert)

    end

    redirect_to action: "index"
  end

  def balance_transaction_params
    params.require(:transaction).permit(:amount)
  end

  def index
    @user = current_user
    @transactions = Transaction.where("user_id = ? AND (committed = false OR actual = true)","#{@user.id}").order(date: :asc, actual: :asc, delta: :desc, description: :asc)

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

    if actuals > 0
      return transactions.drop(actuals - 1)
    end

    return transactions
  end

end
