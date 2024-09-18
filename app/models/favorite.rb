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
    Notification.create(
      user_id: user_id,
      notificable: self,
      read: false
    )
  end
end
