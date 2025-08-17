require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe 'associations' do
    it { should belong_to(:follower).class_name('User') }
    it { should belong_to(:followee).class_name('User') }
  end

  describe 'validations' do
    let(:follower) { create(:user) }
    let(:followee) { create(:user) }

    subject { Follow.new(follower: follower, followee: followee) }

    it { should validate_uniqueness_of(:follower_id).scoped_to(:followee_id) }
  end

  describe 'creating follows' do
    let(:follower) { create(:user) }
    let(:followee) { create(:user) }

    it 'creates a valid follow relationship' do
      follow = Follow.new(follower: follower, followee: followee)
      expect(follow).to be_valid
    end

    it 'prevents duplicate follow relationships' do
      Follow.create!(follower: follower, followee: followee)
      duplicate_follow = Follow.new(follower: follower, followee: followee)
      expect(duplicate_follow).not_to be_valid
    end

    it 'allows the same user to follow multiple users' do
      followee2 = create(:user)
      Follow.create!(follower: follower, followee: followee)
      follow2 = Follow.new(follower: follower, followee: followee2)
      expect(follow2).to be_valid
    end

    it 'allows multiple users to follow the same user' do
      follower2 = create(:user)
      Follow.create!(follower: follower, followee: followee)
      follow2 = Follow.new(follower: follower2, followee: followee)
      expect(follow2).to be_valid
    end
  end
end
