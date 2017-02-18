class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :status
      t.integer :admin_status
      t.datetime :start
      t.datetime :finish
      t.integer :type
      t.float :amount
      t.bigint :source
      
      t.timestamps
    end
  end
end
