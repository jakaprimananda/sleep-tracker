# spec/requests/api/sleep_records_spec.rb
require 'rails_helper'

RSpec.describe 'Api::SleepRecords', type: :request do
  let(:user) { create(:user) }

  describe 'POST /api/sleep_records/clock_in' do
    context 'when not clocked in' do
      it 'creates a new sleep record' do
        expect {
          post '/api/sleep_records/clock_in', headers: auth_headers(user)
        }.to change { user.sleep_records.count }.by(1)

        expect(response).to have_http_status(:created)
        expect(json['clock_in']).not_to be_nil
        expect(json['clock_out']).to be_nil
      end
    end

    context 'when already clocked in' do
      before { create(:sleep_record, user: user, clock_in: 1.hour.ago, clock_out: nil) }

      it 'returns an error' do
        post '/api/sleep_records/clock_in', headers: auth_headers(user)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['error']).to eq('You already have an active sleep record')
      end
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        post '/api/sleep_records/clock_in'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/sleep_records/clock_out' do
    context 'with active sleep record' do
      let!(:sleep_record) { create(:sleep_record, user: user, clock_in: 1.hour.ago, clock_out: nil) }

      it 'updates the sleep record' do
        post '/api/sleep_records/clock_out', headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
        expect(json['clock_out']).not_to be_nil
        expect(json['duration']).not_to be_nil
      end
    end

    context 'without active sleep record' do
      it 'returns an error' do
        post '/api/sleep_records/clock_out', headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('No active sleep record found')
      end
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        post '/api/sleep_records/clock_out'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/sleep_records' do
    let!(:sleep_records) { create_list(:sleep_record, 3, user: user) }

    it 'returns all sleep records for the user' do
      get '/api/sleep_records', headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(3)
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        get '/api/sleep_records'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
