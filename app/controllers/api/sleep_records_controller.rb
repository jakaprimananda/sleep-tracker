class Api::SleepRecordsController < Api::BaseController
  before_action :authenticate_user!

  def clock_in
    if current_user.sleep_records.where(clock_out: nil).exists?
      return render json: { error: "You already have an active sleep record" }, status: :unprocessable_entity
    end

    @sleep_record = current_user.sleep_records.create(clock_in: Time.current)

    render json: @sleep_record, status: :created
  end

  def clock_out
    @sleep_record = current_user.sleep_records.where(clock_out: nil).last

    if @sleep_record.nil?
      return render json: { error: "No active sleep record found" }, status: :not_found
    end

    if @sleep_record.update(clock_out: Time.current)
      render json: @sleep_record.as_json.merge(duration: @sleep_record.duration)
    else
      render json: { errors: @sleep_record.errors }, status: :unprocessable_entity
    end
  end

  def index
    @sleep_records = current_user.sleep_records.order(created_at: :desc)
    render json: @sleep_records
  end
end
