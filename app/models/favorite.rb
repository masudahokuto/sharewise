class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one :notification, as: :notificable, dependent: :destroy

  # 通知機能
  after_create_commit do
    create_notification(user_id: post.user_id)
  end

  validates :user_id, uniqueness: {scope: :post_id} #いいねのバリデーション

  private

  def create_notification(user_id:)
    return if user == post.user # 自分のポストに対する自分の「いいね」は通知しない

    Notification.create(
      user: post.user, # 通知を受け取るユーザー（投稿のユーザー）
      notificable: self,
      read: false
    )
  end
end
