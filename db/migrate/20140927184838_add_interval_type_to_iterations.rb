class AddIntervalTypeToIterations < ActiveRecord::Migration
  def change
    add_column :iterations, :interval_type, :string
  end
end
