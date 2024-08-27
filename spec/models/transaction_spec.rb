require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe '#above_daily_limit?' do
    let(:user_id) { rand(1..1000) }
    let(:transaction_date) { Time.current }
    let!(:transaction) { create(:transaction, user_id: user_id, transaction_date: transaction_date, transaction_amount: 600.00) }

    it 'returns true if the daily total exceeds the limit' do
      create(:transaction, user_id: user_id, transaction_date: transaction_date.beginning_of_day + 2.hours, transaction_amount: 500.00)

      expect(transaction.above_daily_limit?).to be true
    end
  end

  describe '#unusual_time_of_day?' do
    it 'returns true if the transaction is made before 6 AM' do
      transaction = build(:transaction, transaction_date: Time.current.change(hour: 5))
      expect(transaction.unusual_time_of_day?).to be true
    end

    it 'returns true if the transaction is made after 8 PM' do
      transaction = build(:transaction, transaction_date: Time.current.change(hour: 21))
      expect(transaction.unusual_time_of_day?).to be true
    end

    it 'returns false if the transaction is made between 6 AM and 8 PM' do
      transaction = build(:transaction, transaction_date: Time.current.change(hour: 14))
      expect(transaction.unusual_time_of_day?).to be false
    end
  end

  describe '#frequent_transactions?' do
    let(:user_id) { rand(1..1000) }
    
    it 'returns true if there are more than 3 transactions in the last hour' do
      create_list(:transaction, 4, user_id: user_id, transaction_date: 30.minutes.ago)
      transaction = build(:transaction, user_id: user_id)

      expect(transaction.frequent_transactions?).to be true
    end

    it 'returns false if there are 3 or fewer transactions in the last hour' do
      create_list(:transaction, 3, user_id: user_id, transaction_date: 30.minutes.ago)
      transaction = build(:transaction, user_id: user_id)

      expect(transaction.frequent_transactions?).to be false
    end
  end

  describe '#previous_fraud_chargeback?' do
    let(:user_id) { rand(1..1000) }
    let(:card_number) { '4111111111111111' }

    it 'returns true if there is a previous chargeback for the user' do
      create(:transaction, user_id: user_id, has_cbk: true)
      transaction = build(:transaction, user_id: user_id)

      expect(transaction.previous_fraud_chargeback?).to be true
    end

    it 'returns true if there is a previous chargeback for the card' do
      create(:transaction, card_number: card_number, has_cbk: true)
      transaction = build(:transaction, card_number: card_number)

      expect(transaction.previous_fraud_chargeback?).to be true
    end

    it 'returns false if there are no previous chargebacks' do
      transaction = build(:transaction, user_id: user_id, card_number: card_number)

      expect(transaction.previous_fraud_chargeback?).to be false
    end
  end
end


# RSpec.describe Transaction, type: :model do
#   describe 'validations' do
#     it { should validate_presence_of(:transaction_id) }
#     it { should validate_presence_of(:merchant_id) }
#     it { should validate_presence_of(:user_id) }
#     it { should validate_presence_of(:card_number) }
#     it { should validate_presence_of(:transaction_date) }
#     it { should validate_presence_of(:transaction_amount) }
#   end

#   describe '#above_daily_limit?' do
#     let(:user_id) { rand(1..1000) }
#     let(:transaction_date) { Time.current }
#     let(:transaction) { create(:transaction, user_id: user_id, transaction_date: transaction_date, transaction_amount: 600.00) }

#     it 'returns true if the daily total exceeds the limit' do
#       create(:transaction, user_id: user_id, transaction_date: transaction_date.beginning_of_day + 2.hours, transaction_amount: 500.00)

#       expect(transaction.above_daily_limit?).to be true
#     end

#     it 'returns false if the daily total does not exceed the limit' do
#       create(:transaction, user_id: user_id, transaction_date: transaction_date.beginning_of_day + 2.hours, transaction_amount: 300.00)

#       expect(transaction.above_daily_limit?).to be false
#     end
#   end

#   describe '#unusual_time_of_day?' do
#     it 'returns true if the transaction is made before 6 AM' do
#       transaction = build(:transaction, transaction_date: Time.current.change(hour: 5))
#       expect(transaction.unusual_time_of_day?).to be true
#     end

#     it 'returns true if the transaction is made after 8 PM' do
#       transaction = build(:transaction, transaction_date: Time.current.change(hour: 21))
#       expect(transaction.unusual_time_of_day?).to be true
#     end
#   end


#   describe '#frequent_transactions?' do
#     let(:user_id) { rand(1..1000) }
    
#     it 'returns true if there are more than 3 transactions in the last hour' do
#       create_list(:transaction, 4, user_id: user_id, transaction_date: 30.minutes.ago)
#       transaction = build(:transaction, user_id: user_id)

#       expect(transaction.frequent_transactions?).to be true
#     end

#     it 'returns false if there are 3 or fewer transactions in the last hour' do
#       create_list(:transaction, 3, user_id: user_id, transaction_date: 30.minutes.ago)
#       transaction = build(:transaction, user_id: user_id)

#       expect(transaction.frequent_transactions?).to be false
#     end
#   end

#   describe '#previous_fraud_chargeback?' do
#     let(:user_id) { rand(1..1000) }
#     let(:card_number) { '4111111111111111' }

#     it 'returns true if there is a previous chargeback for the user' do
#       create(:transaction, user_id: user_id, has_cbk: true)
#       transaction = build(:transaction, user_id: user_id)

#       expect(transaction.previous_fraud_chargeback?).to be true
#     end

#     it 'returns true if there is a previous chargeback for the card' do
#       create(:transaction, card_number: card_number, has_cbk: true)
#       transaction = build(:transaction, card_number: card_number)

#       expect(transaction.previous_fraud_chargeback?).to be true
#     end

#     it 'returns false if there are no previous chargebacks' do
#       transaction = build(:transaction, user_id: user_id, card_number: card_number)

#       expect(transaction.previous_fraud_chargeback?).to be false
#     end
#   end

#   describe '#evaluate_fraud' do
#     let(:transaction) { build(:transaction) }

#     it 'sets recommendation to "deny" if any fraud condition is met' do
#       allow(transaction).to receive(:above_daily_limit?).and_return(true)
#       transaction.evaluate_fraud
#       expect(transaction.recommendation).to eq('deny')
#     end

#     it 'sets recommendation to "approve" if no fraud condition is met' do
#       allow(transaction).to receive(:above_daily_limit?).and_return(false)
#       allow(transaction).to receive(:frequent_transactions?).and_return(false)
#       allow(transaction).to receive(:previous_fraud_chargeback?).and_return(false)
#       allow(transaction).to receive(:unusual_time_of_day?).and_return(false)
#       transaction.evaluate_fraud
#       expect(transaction.recommendation).to eq('approve')
#     end
#   end
# end
