class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # アクティブなユーザーによるコメントのみを表示する
  scope :active_user_comments, -> { joins(:user).where(users: { is_active: true }) }

  validates :comment, presence: true, length: { maximum: 200 }
end
