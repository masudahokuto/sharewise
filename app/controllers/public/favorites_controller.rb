class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])  # いいねする投稿を取得
    current_user.favorite(@post)

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @post = Post.find(params[:post_id])  # いいねを解除する投稿取得
    current_user.favorites.find_by(post: @post)&.destroy  # ユーザーのいいねを見つけて削除

    respond_to do |format|
      format.js
    end
  end
end
