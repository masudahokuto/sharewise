class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :redirect_if_admin, only: [:index, :show, :mypage]
  before_action :set_user, only: [:show, :edit, :update, :likes]
  before_action :redirect_if_not_current_user, only: [:edit, :update, :likes]

  def mypage
    @user = current_user
    return redirect_to new_user_session_path, alert: 'ログインしてください' unless user_signed_in?
    @posts = newest(@user.posts)
    @links = @user.links

    @notifications = @user.notifications.unread.page(params[:page]).per(20)
    @unread_count = @user.notifications.unread.count
  end

  def index
    @current_user = current_user
    @users = User.includes(:posts).active_users(current_user).order_by_recent.page(params[:page]).per(10)
    if @current_user.present?
      @links = @current_user.links
    else
      @links = [] # ゲストの場合は空の配列を設定
    end
  end

  def show
    return redirect_to mypage_users_path if @user == current_user
    return redirect_to users_path unless @user.is_active?

    @posts = newest(@user.posts)
    @is_following = current_user.following?(@user) if user_signed_in?
    @relationship = current_user.relationships.find_by(followed_id: @user.id) if user_signed_in?
  end

  def likes
    @posts = newest(@user.liked_posts.active_user_posts)
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to mypage_users_path, notice: 'プロフィールが更新されました'
    else
      render :edit
    end
  end

  # 退会処理
  def withdraw
    @user = current_user
    if @user.update(is_active: false)
      sign_out_and_redirect @user
      flash[:notice] = '退会処理が完了しました'
    else
      redirect_to mypage_users_path, alert: '退会処理に失敗しました'
    end
  end

  private

  def newest(posts)
    posts.order(created_at: :desc).page(params[:page]).per(10)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def redirect_if_not_current_user
    redirect_to posts_path unless current_user == @user
  end

  def redirect_if_admin
    redirect_to admin_path, alert: '管理者はこのページにアクセスできません。' if admin_signed_in?
  end

  def user_params
    params.require(:user).permit(:last_name, :first_name, :nick_name, :profile, :gender, :birthday_1i, :birthday_2i, :birthday_3i, :email, :profile_image, :is_active).tap do |whitelisted|
      whitelisted[:profile_image] = nil if params[:user][:remove_profile_image] == '1'
    end
  end
end
