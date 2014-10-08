class AddFieldsToIterations < ActiveRecord::Migration
  def change
    add_column :iterations, :recurrence_code, :string
    add_column :iterations, :iteration, :integer
  end
end
