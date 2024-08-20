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

      expect(json_response['count']['approve']).to eq(approved_transactions.count)
      expect(json_response['count']['deny']).to eq(denied_transactions.count)
      expect(json_response['count']['empty_device_id']).to eq(empty_device_id_transactions.count)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        transaction_id: '12345',
        merchant_id: '54321',
        user_id: 'user_001',
        card_number: '4111111111111111',
        transaction_date: Time.now,
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
        expect(json_response['transaction_id']).to eq(valid_attributes[:transaction_id])
        expect(json_response['recommendation']).to eq('approve')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new transaction and returns an unprocessable entity status' do
        post :create, params: { transaction: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).not_to be_empty
      end
    end
  end
end
