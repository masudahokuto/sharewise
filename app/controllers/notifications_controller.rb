class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def update
    if user_signed_in?
      notification = current_user.notifications.find(params[:id])
      notification.update(read: true)
      case notification.notificable_type
      when "Favorite" # いいね通知の処理
        redirect_to post_path(notification.notificable.post_id)  # いいねされた投稿詳細
      when "Relationship"  # フォロー通知の処理
        redirect_to user_path(notification.notificable.follower_id)  # フォローしてきたユーザーのページ
      else
        redirect_to post_path(notification.notificable.post_id)  # コメントされた投稿詳細
      end
    else
      redirect_to new_user_session_path, alert: 'ログインしてください'
    end
  end
  # 通知全既読
  def mark_all_as_read
    current_user.notifications.where(read: false).update_all(read: true)
    redirect_to mypage_users_path, notice: 'すべての通知を既読にしました'
  end
end
