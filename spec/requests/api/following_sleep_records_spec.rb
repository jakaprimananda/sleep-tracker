# spec/requests/api/following_sleep_records_spec.rb
require 'rails_helper'

RSpec.describe 'Api::FollowingSleepRecords', type: :request do
  let(:user) { create(:user) }
  let(:followed_user1) { create(:user) }
  let(:followed_user2) { create(:user) }

  before do
    create(:follow, follower: user, followee: followed_user1)
    create(:follow, follower: user, followee: followed_user2)

    # Valid records
    @record1 = create(:sleep_record,
                     user: followed_user1,
                     clock_in: 6.days.ago.at_midnight,
                     clock_out: 6.days.ago.at_midnight + 8.hours) # 480 mins

    @record2 = create(:sleep_record,
                     user: followed_user2,
                     clock_in: 5.days.ago.at_midnight,
                     clock_out: 5.days.ago.at_midnight + 7.hours) # 420 mins

    @record3 = create(:sleep_record,
                     user: followed_user1,
                     clock_in: 4.days.ago.at_midnight,
                     clock_out: 4.days.ago.at_midnight + 9.hours) # 540 mins
  end

  describe 'GET /api/following_sleep_records' do
    it 'returns properly sorted sleep records' do
      get '/api/following_sleep_records', headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      # Should return records in correct order (longest duration first)
      expect(json_response.size).to eq(3)
      expect(json_response[0]['id']).to eq(@record3.id)
      expect(json_response[1]['id']).to eq(@record1.id)
      expect(json_response[2]['id']).to eq(@record2.id)

      # Verify duration calculation
      expect(json_response[0]['duration']).to eq(540)
      expect(json_response[1]['duration']).to eq(480)
      expect(json_response[2]['duration']).to eq(420)

      # Verify JSON structure
      expect(json_response.first.keys).to match_array(%w[id clock_in clock_out duration user])
      expect(json_response.first['user'].keys).to match_array(%w[id name])
    end
  end
end
