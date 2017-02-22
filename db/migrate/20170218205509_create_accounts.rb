class CreateAccounts < ActiveRecord::Migration[5.0]
  def change

  	execute 'CREATE SEQUENCE account_id_seq START 100000000;'
    create_table :accounts do |t|
      t.float :balance
      t.integer :status
      t.bigint :account_id
      t.references :user, foreign_key: true
      
      t.timestamps
    end
    execute "ALTER TABLE accounts ALTER COLUMN account_id SET DEFAULT NEXTVAL('account_id_seq');"
  end
end
