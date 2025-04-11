class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    current_user.like(@post)
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: @post, notice: t(".success")) }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("post_#{@post.id}_like", partial: "posts/like_button", locals: { post: @post }) }
    end
  end

  def destroy
    current_user.unlike(@post)
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: @post, notice: t(".success")) }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("post_#{@post.id}_like", partial: "posts/like_button", locals: { post: @post }) }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end