class CreateIterations < ActiveRecord::Migration
  def change
    create_table :iterations do |t|

      t.timestamps
    end
  end
end
