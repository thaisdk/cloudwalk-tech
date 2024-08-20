class Api::V1::TransactionsController < ApplicationController

  def index
    @transactions = Transaction.all
    approved_count = @transactions.where(recommendation: 'approve').count
    denied_count = @transactions.where(recommendation: 'deny').count
    empty_device_id_count = @transactions.where(device_id: nil).count 

    render json: {
    count: {
      approve: approved_count,
      deny: denied_count,
      empty_device_id: empty_device_id_count,
    }
 }, status: :ok
  end


  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.evaluate_fraud

    if @transaction.save
      render json: { transaction_id: @transaction.transaction_id, recommendation: @transaction.recommendation }, status: :created
    else
      render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private def transaction_params
    params.require(:transaction).permit(:transaction_id, :merchant_id, :user_id, :card_number, :transaction_date, :transaction_amount, :device_id)
  end
end

