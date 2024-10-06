class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one :notification, as: :notificable, dependent: :destroy

  # 通知機能
  after_create_commit do
    create_notification(user_id: post.user_id)
  end

  # アクティブユーザーによるコメントのみを表示する
  scope :active_user_comments, -> { joins(:user).where(users: { is_active: true }) }
  default_scope { order(created_at: :desc) }

  validates :comment, presence: true, length: { maximum: 200 }

  private

  def create_notification(user_id:)
    return if user == post.user # 自分のポストに対する自分のコメントは通知しない
    Notification.create(
      user: post.user, # 通知を受け取るユーザー（投稿のユーザー）
      notificable: self,
      read: false
    )
  end
end
