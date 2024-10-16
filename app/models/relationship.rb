class Relationship < ApplicationRecord
  belongs_to :follower, class_name:"User"
  belongs_to :followed, class_name:"User"

  # def create_notification

  #   # 通知の作成
  #   Notification.create(
  #     user: followed.user,        # 通知を受け取るユーザー（フォローされたユーザー）
  #     notificable: self,     # 通知対象（このリレーションシップ）
  #     read: false             # 新しい通知は未読
  #   )
  # end
end