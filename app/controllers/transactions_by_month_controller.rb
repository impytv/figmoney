class TransactionsByMonthController < ApplicationController

  def index
    @user = current_user
    transactions = Transaction.where("user_id = #{@user.id}").order(date: :asc, actual: :asc, delta: :desc, description: :asc)

    transactions = process_transactions(transactions)

    @monthly_transactions = []
    last_month = 0
    last_amount = 0
    previous_month_transaction = Transaction.new
    previous_month_transaction.amount = 0

    transactions.each do |transaction|
      if last_month != transaction.date.month
        monthly_transaction = Transaction.new
        monthly_transaction.date = Date.new(transaction.date.year, transaction.date.month, 1)
        monthly_transaction.amount = last_amount
        monthly_transaction.description = transaction.date.strftime('%Y %B')

        @monthly_transactions.push(monthly_transaction)

        previous_month_transaction.delta = last_amount - previous_month_transaction.amount

        previous_month_transaction = monthly_transaction

        last_month = transaction.date.month
      end

      last_amount = transaction.amount
    end

    previous_month_transaction.delta = last_amount - previous_month_transaction.amount
  end

  def process_transactions(transactions)
    amount = 0.0
    transactions.each do |transaction|
      if transaction.actual
        amount = transaction.amount
      else
        amount = amount + transaction.delta
        transaction.amount = amount
      end
    end

    return transactions
  end

end
