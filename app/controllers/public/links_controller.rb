class Public::LinksController < ApplicationController
  before_action :authenticate_user!  # ログインユーザーのみアクセス可能にする

  def new
    @user = current_user
    @link = @user.links.new
    @links = @user.links.includes(:user)
    # ソート(モデルに記述あり)
    @sort_order = params[:sort_order] || 'created_at'
    @sorted_links = Link.sort_links(@sort_order).where(user_id: current_user.id)
  end

  def create
    @link = current_user.links.new(link_params)
    if @link.save
      redirect_to new_user_link_path(current_user), notice: 'リンクが登録されました。'
    else
      render :new
    end
  end

  def destroy
    @link = current_user.links.find(params[:id])
    @link.destroy
    redirect_to new_user_link_path(current_user), notice: 'リンクが削除されました。'
  end

  private

  def link_params
    params.require(:link).permit(:link_name, :web_url)
  end
end
