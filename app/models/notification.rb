class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notificable, polymorphic: true
  # 通知が未読のものを取得するスコープ
  scope :unread, -> { where(read: false) }
end
