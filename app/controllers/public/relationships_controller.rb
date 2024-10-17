class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  # フォロー一覧
  def followings
    @current_user = current_user
    @user = User.find(params[:user_id])
    @followings = @user.followings.page(params[:page]).per(50)
  end

  # フォロワー一覧
  def followers
    @current_user = current_user
    @user = User.find(params[:user_id])
    @followers = @user.followers.page(params[:page]).per(50)
  end


  def create
    # params[:followed_id] が存在するか確認
    if params[:followed_id].present?
      @user = User.find_by(id: params[:followed_id])
      if @user
        # フォロー処理
        relationship = current_user.follow(@user)
        Notification.create(user: @user, notificable: relationship, read: false)
        redirect_back(fallback_location: root_path, notice: 'フォローしました')
      else
        redirect_back(fallback_location: root_path, alert: 'ユーザーが見つかりません')
      end
    else
      redirect_back(fallback_location: root_path, alert: 'ユーザーIDが指定されていません')
    end
  end

  def destroy
    @user = User.find(params[:id])
    current_user.unfollow(@user)

    redirect_back(fallback_location: root_path, alert: 'フォローを外しました')
  end
end