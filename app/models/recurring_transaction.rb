class RecurringTransaction < ActiveRecord::Base

  def normalized_month
    @normalized_month.round(1)
  end

  def normalized_month=(val)
    @normalized_month = val
  end
  
end
