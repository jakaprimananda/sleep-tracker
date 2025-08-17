class Api::FollowsController < Api::BaseController
  before_action :authenticate_user!

  def create
    followee = User.find(params[:followee_id])

    if current_user.followees.include?(followee)
      return render json: { error: "Already following this user" }, status: :unprocessable_entity
    end

    @follow = current_user.followed_users.create(followee: followee)

    if @follow.persisted?
      render json: @follow, status: :created
    else
      render json: { errors: @follow.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @follow = current_user.followed_users.find_by(followee_id: params[:id])

    if @follow.nil?
      return render json: { error: "Follow relationship not found" }, status: :not_found
    end

    if @follow.destroy
      head :no_content
    else
      render json: { errors: @follow.errors }, status: :unprocessable_entity
    end
  end
end
