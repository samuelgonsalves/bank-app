class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.float :balance
      t.integer :status
      t.bigint :account_id
      t.references :user, foreign_key: true
      
      t.timestamps
    end
  end
end
