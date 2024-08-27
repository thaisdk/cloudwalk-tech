FactoryBot.define do
  factory :transaction do
    transaction_id { SecureRandom.uuid }
    merchant_id { "merchant_#{SecureRandom.hex(4)}" }
    user_id { "user_#{SecureRandom.hex(4)}" }
    card_number { "4111111111111111" }
    transaction_date { Time.now }
    transaction_amount { rand(1.00..1000.00) }
    device_id { SecureRandom.hex(4) }
    recommendation { 'approve' }
    has_cbk { false }
  end
end
