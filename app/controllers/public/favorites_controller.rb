class Public::FavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.create(post_id: @post.id)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js   # create.js.erb を呼び出す
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(post_id: @post.id)
    @favorite.destroy

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js   # destroy.js.erb を呼び出す
    end
  end
end
