class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update]
  def new
    @user = current_user
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params) # current_user を使用して投稿を作成
    if @post.save
      redirect_to mypage_users_path
    else
      flash[:alert] = '投稿に失敗しました'
      render :new
    end
  end

  def index
    @current_user = current_user
    @posts = Post.active_user_posts.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @post = Post.find_by(id: params[:id])
    # @post_comments = @post.post_comments.page(params[:page]).per(1)
    if @post.nil? || !@post.user.is_active
      redirect_to posts_path, alert: '投稿が見つからないか、ユーザーが退会しています。'
    else
      @user = @post.user
      @post_comment = PostComment.new
    end
  end

  def edit
    @user = current_user
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: '編集に成功しました'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  # 自分以外のuserがedit、update、destroy出来ないようにする
  def correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path
    end
  end

  def post_params
    params.require(:post).permit(:body, :user_id, images: [])
  end
end
