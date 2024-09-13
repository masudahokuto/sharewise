class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.favorite(@post)
    respond_to do |format|
      format.js
    end
  end
  # 後でモデルに記述する
  def destroy
    @post = Post.find(params[:post_id])
    current_user.favorites.find_by(post: @post)&.destroy
    respond_to do |format|
      format.js
    end
  end
end
