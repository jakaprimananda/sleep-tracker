# app/controllers/api/following_sleep_records_controller.rb
class Api::FollowingSleepRecordsController < Api::BaseController
  def index
    last_week = 1.week.ago.beginning_of_day
    followee_ids = current_user.followed_users.pluck(:followee_id)

    # Base query with all conditions
    @sleep_records = SleepRecord
      .includes(:user)
      .where(user_id: followee_ids)
      .where("clock_in >= ?", last_week)
      .where.not(clock_out: nil)
      .order(Arel.sql("EXTRACT(EPOCH FROM (clock_out - clock_in)) / 60 DESC"))

    # Serialize with calculated duration
    render json: @sleep_records.as_json(
      only: [:id, :clock_in, :clock_out],
      methods: [:duration],
      include: {
        user: {
          only: [:id, :name]
        }
      }
    )
  end
end
