class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :show ]

  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    
    @posts = @user.posts.order(created_at: :desc)
    
    # グラフデータは回答がある場合のみ準備
    @chart_data = @user.answers.any? ? prepare_chart_data(@user) : { labels: [], data: [] }
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
    params.require(:user).permit(:username, :bio, :avatar)
  end

  def prepare_chart_data(user)
    daily_stats = user.daily_answer_stats

    {
      labels: daily_stats.map { |stat| stat[:date] },
      data: daily_stats.map { |stat| stat[:correct_rate] }
    }
  end
end
