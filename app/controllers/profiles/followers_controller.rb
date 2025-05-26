class Profiles::FollowingsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  
  def index
    @user = User.find(params[:profile_id])
    @users = @user.following.order(created_at: :desc)
  end
end