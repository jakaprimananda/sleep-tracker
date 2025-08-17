# spec/requests/api/follows_spec.rb
require 'rails_helper'

RSpec.describe 'Api::Follows', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'POST /api/follows' do
    it 'creates a follow relationship' do
      expect {
        post '/api/follows', params: { followee_id: other_user.id }, headers: auth_headers(user)
      }.to change { Follow.count }.by(1)

      expect(response).to have_http_status(:created)
    end

    context 'when already following' do
      before { create(:follow, follower: user, followee: other_user) }

      it 'returns an error' do
        post '/api/follows', params: { followee_id: other_user.id }, headers: auth_headers(user)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['error']).to eq('Already following this user')
      end
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        post '/api/follows', params: { followee_id: other_user.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/follows/:id' do
    let!(:follow) { create(:follow, follower: user, followee: other_user) }

    it 'destroys the follow relationship' do
      expect {
        delete "/api/follows/#{other_user.id}", headers: auth_headers(user)
      }.to change { Follow.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end

    context 'when not following' do
      before { follow.destroy }

      it 'returns an error' do
        delete "/api/follows/#{other_user.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('Follow relationship not found')
      end
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        delete "/api/follows/#{other_user.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
