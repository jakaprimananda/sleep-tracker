class SleepRecord < ApplicationRecord
  belongs_to :user

  # Validation
  validates :clock_in, presence: true

  def calculate_duration
    if clock_in.present? && clock_out.present?
      ((clock_out - clock_in) / 60).to_i
    end
  end
end
