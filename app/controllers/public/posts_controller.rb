class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params) # current_user を使用して投稿を作成
    if @post.save
      redirect_to mypage_users_path, notice: '投稿に成功しました'
    else
      flash[:alert] = '投稿に失敗しました'
      render :new
    end
  end

  def index
    @current_user = current_user
    @posts = Post.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])  # Postを検索
    @user = @post.user              # Postの所有者であるUserを取得
  end

  def edit
    # @post は before_action で設定されている
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: '編集に成功しました'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:body, :user_id, images: [])
  end
end
