require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:sleep_records) }
    it { should have_many(:followed_users).with_foreign_key(:follower_id).class_name('Follow') }
    it { should have_many(:followees).through(:followed_users) }
    it { should have_many(:following_users).with_foreign_key(:followee_id).class_name('Follow') }
    it { should have_many(:followers).through(:following_users) }
  end

  describe 'follow functionality' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:follow) { create(:follow, follower: user, followee: other_user) }

    it 'can follow other users' do
      follow
      expect(user.followees).to include(other_user)
    end

    it 'can have followers' do
      follow
      expect(other_user.followers).to include(user)
    end
  end

  describe 'sleep records' do
    let(:user) { create(:user) }
    let!(:sleep_record) { create(:sleep_record, user: user) }

    it 'can have sleep records' do
      expect(user.sleep_records).to include(sleep_record)
    end
  end
end
