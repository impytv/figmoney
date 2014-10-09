class RecurringTransactionsController < ApplicationController
  def new
  end

  def index
    @recurring_transactions = RecurringTransaction.all.order(:date_from)
  end

  def edit
    @recurring_transaction = RecurringTransaction.find(params[:id])
  end

  def update
    recurring_transaction = RecurringTransaction.find(params[:id])

    recurring_transaction.update(recurring_transaction_params)

    simulate_transactions(recurring_transaction.id)

    redirect_to action: "index"
  end

  def create
    recurring_transaction = RecurringTransaction.new(recurring_transaction_params)
    recurring_transaction.last_iteration = 0
    if recurring_transaction.date_to.nil?
      recurring_transaction.date_to = Date.new(3010,12,31)
    end

    recurring_transaction.save

    simulate_transactions(recurring_transaction.id)

    redirect_to action: "index"
  end

  def simulate_transactions(recurrence_id)
    ActiveRecord::Base.transaction do
      #Delete previously simulated and unchanged
      delete = "DELETE FROM transactions WHERE committed = false AND overridden_amount = false AND recurrence_id = #{recurrence_id}"
      Transaction.connection.execute(delete)
      #Insert new simulated transactions

      insert = "INSERT INTO transactions (description, delta, iteration, recurrence_id, date, committed, overridden_amount, created_at, updated_at)
    SELECT r.description, r.amount, r.last_iteration + i.iteration, r.id, r.date_from + i.stride * interval '1 day', false, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM recurring_transactions r, iterations i
     WHERE r.recurrence_code = i.recurrence_code
       AND i.interval_type = 'D'
       AND r.id = #{recurrence_id}
       AND r.date_from + i.stride * interval '1 day' BETWEEN r.date_from AND r.date_to
       AND (r.last_iteration + i.iteration) NOT IN (SELECT iteration FROM transactions WHERE recurrence_id = #{recurrence_id})
     UNION ALL
    SELECT r.description, r.amount, r.last_iteration + i.iteration, r.id, r.date_from + i.stride * interval '1 month', false, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM recurring_transactions r, iterations i
     WHERE r.recurrence_code = i.recurrence_code
       AND i.interval_type = 'M'
       AND r.id = #{recurrence_id}
       AND r.date_from + i.stride * interval '1 month' BETWEEN r.date_from AND r.date_to
       AND (r.last_iteration + i.iteration) NOT IN (SELECT iteration FROM transactions WHERE recurrence_id = #{recurrence_id})"

      Transaction.connection.execute(insert)
    end
  end

  def recurring_transaction_params
    params.require(:recurring_transaction).permit(:description, :date_from, :date_to, :recurrence_code, :amount)
  end

end
