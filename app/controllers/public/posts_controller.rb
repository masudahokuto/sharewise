class Public::PostsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper  # HTMLタグを除去するためのヘルパー
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:edit, :update, :destroy, :correct_user]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :redirect_if_admin, only: [:index, :show]  # 管理者リダイレクト

  def new
    @current_user = current_user
    @post = current_user.posts.new
    @links = current_user.links
  end

  def create
    sanitized_body = sanitize_post_body(post_params[:body])  # HTMLタグを除去
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
    @posts = Post.active_user_posts
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(10)
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
    @posts = Post.active_user_posts
                 .search_by_body(params[:query])
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(10)
  end

  def edit
  end

  def update
    sanitized_body = sanitize_post_body(post_params[:body])  # HTMLタグを除去
    if @post.update(post_params.merge(body: sanitized_body))
      redirect_to @post
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to mypage_users_path
  end

  # コンテンツからの投稿作成機能
  def create_from_content
    content = Content.find(params[:id])
    sanitized_body = sanitize_content(content)  # HTMLタグを除去

    @post = current_user.posts.new(
      body: sanitized_body
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

  # パラメータを許可するメソッド
  def post_params
    params.require(:post).permit(:body, images: [])
  end

  # 投稿が自分のものであるかを確認するメソッド
  def correct_user
    redirect_to posts_path unless @post.user == current_user
  end

  # 現在の投稿を取得するメソッド
  def set_post
    @post = Post.find(params[:id])
  end

  # 管理者としてサインインしている場合にリダイレクト
  def redirect_if_admin
    redirect_to admin_path, alert: "管理者はこのページにアクセスできません。" if admin_signed_in?
  end

  # 投稿内容をサニタイズするメソッド
  def sanitize_post_body(body)
    strip_tags(body)  # HTMLタグを除去
  end

  # コンテンツの内容をサニタイズするメソッド
  def sanitize_content(content)
    combined_content = "#{content.content_name}\n\n#{content.body}"
    strip_tags(combined_content)  # HTMLタグを除去
  end

  # コンテンツの画像を投稿にコピーするメソッド
  def copy_content_images(content)
    content.images.each { |image| @post.images.attach(image.blob) } if content.images.attached?
  end
end
