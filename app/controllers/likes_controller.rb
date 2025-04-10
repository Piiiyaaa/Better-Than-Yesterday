class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    current_user.like(@post)
    redirect_to @post, notice: t(".success")
  end

  def destroy
    current_user.unlike(@post)
    redirect_to @post, notice: t(".success")
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
