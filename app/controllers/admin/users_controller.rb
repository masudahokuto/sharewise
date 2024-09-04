class Manager::UsersController < ApplicationController
  before_action :authenticate_admin!  # 管理者がログインしていることを確認

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'ユーザー情報が更新されました'
    else
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :nick_name, :profile, :gender, :birthday, :email, :profile_image, :is_active)
  end
end
