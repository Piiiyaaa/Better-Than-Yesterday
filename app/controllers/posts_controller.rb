class PostsController < ApplicationController
    before_action :authenticate_user!, except: [ :index ]
    before_action :set_post, only: [ :show, :edit, :update, :destroy ]
    before_action :check_post_owner, only: [ :edit, :update, :destroy ]

    def index
        @posts = Post.includes(:user, :tags).order(learning_date: :desc, created_at: :desc)
        @tags = Tag.all.order(name: :asc)
    end

    def new
        @post = Post.new
        @post.build_daily_question
    end

    def create
        @post = current_user.posts.build(post_params)
        if @post.save
            redirect_to posts_path, notice: t(".success")
        else
            flash.now[:alert] = t(".failure")
            render :new, status: :unprocessable_entity
        end
    end

    def show
        @daily_question = @post.daily_question
        @user = @post.user  # 投稿の作者を @user に設定
    end

    def edit
        @daily_question = @post.daily_question
    end

    def update
        if @post.update(post_params)
          redirect_to post_path(@post), notice: t(".success")
        else
          flash.now[:alert] = t("posts.update.failure")
          render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @post.destroy
        redirect_to posts_path, notice: t("posts.destroy.success"), status: :see_other
    end

    private

    def set_post
        @post = Post.find(params[:id])
    end

    def post_params
        params.require(:post).permit(:title, :body, :learning_date, :image, :tag_names,
        daily_question_attributes: [ :body, :question_answer ])
    end

    def check_post_owner
        unless @post.user == current_user
            redirect_to posts_path, alert: t("errors.messages.unauthorized_edit_post")
        end
    end
end
