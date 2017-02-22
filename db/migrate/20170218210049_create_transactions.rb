class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :status 
      t.datetime :start
      t.datetime :finish
      t.float :amount
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
