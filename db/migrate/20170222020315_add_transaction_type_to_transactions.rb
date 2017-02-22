class AddTransactionTypeToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :transaction_type, :integer
  end
end
