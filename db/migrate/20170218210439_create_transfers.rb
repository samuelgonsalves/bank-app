class CreateTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :transfers do |t|
      t.bigint :destination
      t.references :transaction
      t.timestamps
    end
  end
end
