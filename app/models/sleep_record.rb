class SleepRecord < ApplicationRecord
  belongs_to :user

  # Validation
  validates :clock_in, presence: true

  def duration
    return nil unless clock_out.present?
    ((clock_out - clock_in) / 60).to_i # Duration in minutes
  end
end
