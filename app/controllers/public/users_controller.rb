class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index]  # ユーザーがログインしていることを確認

  def mypage
    @user = current_user
    @posts = @user.posts.page(params[:page]).per(10)
  end

def index
  @current_user = current_user
  @users = User.where.not(id: @current_user.id).page(params[:page]).per(10) if @current_user
  @users ||= User.all.page(params[:page]).per(10) # ログインしていない場合は全ユーザーを取得
end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
    # ユーザーが自分のプロフィールを編集できるかを確認する
    redirect_to mypage_path unless @user == current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to mypage_users_path, notice: 'プロフィールが更新されました'
    else
      render :edit
    end
  end

  def withdraw
    @user = current_user
    if @user.update(is_active: false)
      sign_out_and_redirect @user
      flash[:notice] = '退会処理が完了しました'
    else
      redirect_to mypage_path, alert: '退会処理に失敗しました'
    end
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :nick_name, :profile, :gender, :birthday_1i, :birthday_2i, :birthday_3i, :email, :profile_image, :is_active)
  end
end
