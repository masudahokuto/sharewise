class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    @post = Post.find(params[:post_id])
    @post_comment = @post.post_comments.find(params[:id])
    @post_comment.destroy
    redirect_to admin_post_path(@post)
  end
end
