class AddStrideToIterations < ActiveRecord::Migration
  def change
    add_column :iterations, :stride, :integer
  end
end
