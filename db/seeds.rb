require 'csv'

file_path = 'db/sample/transactional-sample.csv'

puts "Reading csv file... "

CSV.foreach(file_path,headers: true) do |row|
  transaction = Transaction.create(
    transaction_id: row["transaction_id"],
    merchant_id: row["merchant_id"],
    user_id: row["user_id"],
    card_number: row["card_number"],
    transaction_date: DateTime.parse(row["transaction_date"]),
    transaction_amount: row["transaction_amount"].to_d,
    device_id: row["device_id"],
    has_cbk: row["has_cbk"].downcase
  )
  transaction.evaluate_fraud
  transaction.save
end

puts "Successfully imported data from #{file_path}."
puts "Added #{Transaction.count} transactions to database."