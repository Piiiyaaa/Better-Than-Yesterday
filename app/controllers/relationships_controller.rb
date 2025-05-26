class RelationshipsController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @user = User.find(params[:followed_id])
      current_user.follow(@user)
      
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.turbo_stream
      end
    end
  
    def destroy
        @user = User.find_by(id: params[:followed_id])
      
        if @user
          relationship = current_user.active_relationships.find_by(followed_id: @user.id)
      
          if relationship
            relationship.destroy
          else
            redirect_back(fallback_location: root_path, alert: "フォロー関係が見つかりませんでした") and return
          end
        else
          redirect_back(fallback_location: root_path, alert: "ユーザーが見つかりませんでした") and return
        end
      
        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path) }
          format.turbo_stream
        end
      end
      
  end