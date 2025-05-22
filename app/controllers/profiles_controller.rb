class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :show ]

  def show
    @user = params[:id] ? @user : current_user
    @posts = @user.posts.order(created_at: :desc)
    @chart_data = prepare_chart_data(@user)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: t("profiles.update.success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id]) if params[:id]
  end

  def user_params
    params.require(:user).permit(:username, :bio)
  end

  def prepare_chart_data(user)
    daily_stats = user.daily_answer_stats

    {
      labels: daily_stats.map { |stat| stat[:date] },
      data: daily_stats.map { |stat| stat[:correct_rate] }
    }
  end
end
