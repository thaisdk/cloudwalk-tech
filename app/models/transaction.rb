class Transaction < ApplicationRecord
  validates :transaction_id, :merchant_id, :user_id, :card_number, :transaction_date, :transaction_amount, presence: true
  validates :device_id, presence: true, if: -> { device_id.present? }
  
  TRANSACTIONS_IN_ROW = 3
  MAX_DAILY_AMOUNT = 1000.00

  def above_daily_limit?
    start_of_day = transaction_date.beginning_of_day
    end_of_day = transaction_date.end_of_day

    daily_total = Transaction.where(user_id: user_id)
                             .where('transaction_date >= ?', start_of_day)
                             .where('transaction_date < ?', end_of_day)
                             .sum(:transaction_amount)

    (daily_total + transaction_amount) > MAX_DAILY_AMOUNT
  end

  def unusual_time_of_day?
    return false if transaction_date.nil?

    transaction_date.hour < 6 || transaction_date.hour > 20
  end

  def frequent_transactions?
    recent_transactions_count > TRANSACTIONS_IN_ROW
  end

  def previous_fraud_chargeback?
    Transaction.where(user_id: user_id, has_cbk: true).exists? || 
    Transaction.where(card_number: card_number, has_cbk: true).exists?
  end

  def recent_transactions_count
    Transaction.where(user_id: user_id).where('transaction_date >= ?', 1.hour.ago).count
  end

  def evaluate_fraud
    if above_daily_limit? || frequent_transactions? || previous_fraud_chargeback? || unusual_time_of_day?
      self.recommendation = "deny"
    else 
      self.recommendation = "approve"
    end
  end
end
