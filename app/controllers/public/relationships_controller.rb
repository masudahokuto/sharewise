class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  # フォローしているユーザー一覧
  def followings
    @user = User.find(params[:user_id])
    @followings = @user.followings.page(params[:page]).per(50)
  end

  # フォロワー一覧
  def followers
    @user = User.find(params[:user_id])
    @followers = @user.followers.page(params[:page]).per(50)
  end


  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    redirect_to user_path(@user)
  end

  def destroy
    @user = User.find(params[:id])
    current_user.unfollow(@user)
    redirect_to user_path(@user)
  end
end