class CreateTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :transfers do |t|
      t.references :account, foreign_key: true
      t.references :transaction, foreign_key: true

      t.timestamps
    end
  end
end
