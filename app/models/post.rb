class Post < ApplicationRecord
  # アソシエーション
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many_attached :images

  # バリデーション
  validates :body, presence: true, length: { maximum: 3000 }
  validate :images_format, :image_length, :reject_forbidden_words

  validates :images, content_type: { in: ['image/jpg', 'image/jpeg', 'image/png'] }
  validates :images, size: { less_than: 5.megabytes }

  # スコープ
  scope :active_user_posts, -> { joins(:user).where(users: { is_active: true }) }
  scope :liked_by, -> (user) { joins(:favorites).where(favorites: { user_id: user.id }) }
  scope :search_by_body, ->(query) { where('body LIKE ?', "%#{query}%") }

  # 通算いいね数順
  scope :order_by_favorites_count, -> {
    left_joins(:favorites)
    .group('posts.id')
    .order('COUNT(favorites.id) DESC')
  }

  # 日間いいね数順
  scope :order_by_daily_favorites_count, -> {
    left_joins(:favorites)
    .where('favorites.created_at >= ?', Time.zone.now.beginning_of_day)
    .group('posts.id')
    .order('COUNT(favorites.id) DESC')
  }
  
  # 週間いいね数順
  scope :order_by_weekly_favorites_count, -> {
    left_joins(:favorites)
    .where('favorites.created_at >= ?', 1.week.ago)
    .group('posts.id')
    .order('COUNT(favorites.id) DESC')
  }
  
  # 月間いいね数順
  scope :order_by_monthly_favorites_count, -> {
    left_joins(:favorites)
    .where('favorites.created_at >= ?', 1.month.ago)
    .group('posts.id')
    .order('COUNT(favorites.id) DESC')
  }
  
  # メソッド
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  private

  def images_format
    return unless images.attached?

    images.each do |image|
      unless image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:images, 'にはJPEGまたはPNGの画像ファイルを指定してください。')
      end
    end
  end

  def image_length
    errors.add(:images, "は3枚以内にしてください") if images.length >= 4
  end

  def reject_forbidden_words
    errors[:base] << "エラーが発生しました" if body.include?("投稿はできません")
  end
end
