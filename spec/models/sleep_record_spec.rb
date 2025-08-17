require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  let(:user) { create(:user) }
  let(:sleep_record) { build(:sleep_record, user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:clock_in) }
  end

  describe '#calculate_duration' do
    context 'when both clock_in and clock_out are present' do
      it 'returns duration in minutes' do
        clock_in = Time.current
        clock_out = clock_in + 8.hours
        sleep_record.clock_in = clock_in
        sleep_record.clock_out = clock_out

        expect(sleep_record.calculate_duration).to eq(480)
      end
    end

    context 'when clock_out is nil' do
      it 'returns nil' do
        sleep_record.clock_in = Time.current
        sleep_record.clock_out = nil

        expect(sleep_record.calculate_duration).to be_nil
      end
    end

    context 'when clock_in is nil' do
      it 'returns nil' do
        sleep_record.clock_in = nil
        sleep_record.clock_out = Time.current

        expect(sleep_record.calculate_duration).to be_nil
      end
    end

    context 'when both clock_in and clock_out are nil' do
      it 'returns nil' do
        sleep_record.clock_in = nil
        sleep_record.clock_out = nil

        expect(sleep_record.calculate_duration).to be_nil
      end
    end
  end
end
