class Public::PostsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper  # HTMLタグを除去するためのヘルパー
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :redirect_if_admin, only: [:index, :show]  # 管理者リダイレクト

  def new
    @user = current_user
    @post = Post.new
    @links = @user.links
  end

  def create
    sanitized_body = strip_tags(post_params[:body])  # HTMLタグを除去
    @post = current_user.posts.new(post_params.merge(body: sanitized_body))

    if @post.save
      flash[:success] = "投稿しました"
      redirect_to mypage_users_path
    else
      flash[:alert] = "こちらの内容は投稿出来ません"
      redirect_back(fallback_location: root_path)
    end
  end

  def index
    @current_user = current_user
    @posts = Post.active_user_posts.order(created_at: :desc).page(params[:page]).per(10)  # 投稿を取得
    @posts = @posts.search(params[:query]) if params[:query].present?  # 検索機能
  end

  def show
    @current_user = current_user
    @post = Post.find_by(id: params[:id])
    if @post.nil? || !@post.user.is_active
      redirect_to posts_path
    else
      @user = @post.user
      @post_comments = @post.post_comments.active_user_comments.page(params[:page]).per(10)  # コメントを取得
      @post_comment = PostComment.new
    end
    @is_following = current_user.following?(@user) if current_user.present?  # フォロー状態を確認
    @relationship = current_user.relationships.find_by(followed_id: @user.id) if user_signed_in?  # フォロワー関係を取得
  end

  def search
    @current_user = current_user
    @posts = Post.active_user_posts.search_by_body(params[:query]).order(created_at: :desc).page(params[:page]).per(10)  # 検索結果を取得
  end

  def edit
    @user = current_user
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to mypage_users_path
  end

  # コンテンツからの投稿作成機能
  def create_from_content
    content = Content.find(params[:id])
    sanitized_body = sanitize_content(content)  # HTMLタグを除去

    @post = Post.new(
      body: sanitized_body,
      user_id: current_user.id
    )

    copy_content_images(content)  # コンテンツの画像を投稿にコピー

    if @post.save
      flash[:success] = "投稿しました"
      redirect_to post_path(@post)
    else
      flash[:alert] = "エラーが発生しました"
      redirect_to root_path
    end
  end

  private

  # 自分以外のユーザーがedit、update、destroyできないようにする
  def correct_user
    @post = Post.find(params[:id])
    redirect_to posts_path unless @post.user == current_user  # 認可されていない場合はリダイレクト
  end

  def post_params
    params.require(:post).permit(:body, :user_id, images: [])  # 投稿パラメータを許可
  end

  def redirect_if_admin
    redirect_to admin_path, alert: "管理者はこのページにアクセスできません。" if admin_signed_in?  # 管理者リダイレクト
  end

  # コンテンツの内容をサニタイズするメソッド
  def sanitize_content(content)
    combined_content = "#{content.content_name}\n\n#{content.body}"
    strip_tags(combined_content)  # HTMLタグを除去
  end

  # コンテンツの画像を投稿にコピーするメソッド
  def copy_content_images(content)
    if content.images.attached?
      content.images.each { |image| @post.images.attach(image.blob) }  # 画像をコピー
    end
  end
end
