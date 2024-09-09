class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy

  has_many_attached :images  # 複数画像

  validates :body, presence: true
  validate :images_format
  validate :image_length
  private

  # 退会したユーザーのコメントを除外
  scope :active_user_posts, -> { joins(:user).where(users: { is_active: true }) }

  def images_format
    if images.attached?
      images.each do |image|
        unless image.content_type.in?(%('image/jpeg image/png'))
          errors.add(:images, 'にはJPEGまたはPNGの画像ファイルを指定してください。')
        end
      end
    end
  end

  def image_length
    if images.length >= 4
      errors.add(:images, "は3枚以内にしてください")
    end
  end
end
