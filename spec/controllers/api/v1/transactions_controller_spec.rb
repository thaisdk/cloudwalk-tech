require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  describe 'GET #index' do
    let!(:approved_transactions) { create_list(:transaction, 3, recommendation: 'approve') }
    let!(:denied_transactions) { create_list(:transaction, 2, recommendation: 'deny') }
    let!(:empty_device_id_transactions) { create_list(:transaction, 2, device_id: nil) }

    it 'returns the correct count of approved, denied, and empty_device_id transactions' do
      get :index

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response['count']['approve']).to eq(Transaction.where(recommendation: 'approve').count)
      expect(json_response['count']['deny']).to eq(Transaction.where(recommendation: 'deny').count)
      expect(json_response['count']['empty_device_id']).to eq(Transaction.where(device_id: nil).count)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        transaction_id: '12345',
        merchant_id: '54321',
        user_id: 'user_001',
        card_number: '4111111111111111',
        transaction_date: Time.current,
        transaction_amount: 500.00,
        device_id: 'device_001'
      }
    end

    let(:invalid_attributes) do
      {
        transaction_id: nil,
        merchant_id: nil,
        user_id: nil,
        card_number: nil,
        transaction_date: nil,
        transaction_amount: nil,
        device_id: nil
      }
    end

    context 'with valid attributes' do
      it 'creates a new transaction and returns a created status' do
        post :create, params: { transaction: valid_attributes }

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['transaction_id'].to_s).to eq(valid_attributes[:transaction_id])
        expect(json_response['recommendation']).to eq('approve')
      end
    end
  end
end
