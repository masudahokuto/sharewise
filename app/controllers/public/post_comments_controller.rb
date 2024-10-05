class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    @post_comments = @post.post_comments.active_user_comments.page(params[:page]).per(10)
    @comment.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = PostComment.find(params[:id])
    @post_comments = @post.post_comments.active_user_comments.page(params[:page]).per(10)
    @comment.destroy
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
