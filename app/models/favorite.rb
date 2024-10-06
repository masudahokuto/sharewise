class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one :notification, as: :notificable, dependent: :destroy  # 通知機能の関連

  # 通知機能
  after_create_commit do
    create_notification(user_id: post.user_id)  # 投稿のユーザーに通知を作成
  end

  # いいねのバリデーション
  validates :user_id, uniqueness: { scope: :post_id }  # 同じ投稿に対して同じユーザーがいいねできないようにする

  private

  # 通知を作成メソッド
  def create_notification(user_id:)
    return if user == post.user  # 自分の投稿に対する自分のいいねは通知しない

    # 通知の作成
    Notification.create(
      user: post.user,  # 通知を受け取るユーザー（投稿のユーザー）
      notificable: self,  # 通知対象
      read: false  # 新しい通知は未読
    )
  end
end
