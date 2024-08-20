class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.integer :transaction_id
      t.integer :merchant_id
      t.integer :user_id
      t.string :card_number
      t.datetime :transaction_date
      t.decimal :transaction_amount
      t.integer :device_id
      t.string :recommendation
      t.string :has_cbk

      t.timestamps
    end
  end
end
