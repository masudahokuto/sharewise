class Public::PostCommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = post.id
    if comment.save
      redirect_to request.referer, notice: 'コメントが追加されました。'
    else
      redirect_to request.referer, alert: 'コメントの追加に失敗しました。'
    end
  end

  def destroy
    comment = PostComment.active_user_comments.find(params[:id])
    if comment.destroy
      redirect_to request.referer, notice: 'コメントが削除されました。'
    else
      redirect_to request.referer, alert: 'コメントの削除に失敗しました。'
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
