class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  #Postがfavoritesを介してUserに関連付けられfavorited_by_usersメソッドを使用してポストをいいねしたユーザーを取得
  has_many :favorited_by_users, through: :favorites, source: :user

  has_many_attached :images  # 複数画像

  validates :body, presence: true
  validate :images_format
  validate :image_length

  # 退会したユーザーのコメントを除外
  scope :active_user_posts, -> { joins(:user).where(users: { is_active: true }) }

  # 画像の拡張子指定
  def images_format
    if images.attached?
      images.each do |image|
        unless image.content_type.in?(%('image/jpeg image/png'))
          errors.add(:images, 'にはJPEGまたはPNGの画像ファイルを指定してください。')
        end
      end
    end
  end

  # 画像3枚まで
  def image_length
    if images.length >= 4
      errors.add(:images, "は3枚以内にしてください")
    end
  end

  # いいねテーブルにuser_idが存在していればtrueしていなければfalseを返す
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  # アクティブなユーザーの投稿を取得するスコープ
  scope :active_user_posts, -> {
    joins(:user).where(users: { is_active: true })
  }

  # ユーザーがいいねした投稿を取得するスコープ
  scope :liked_by, -> (user) {
    joins(:favorites).where(favorites: { user_id: user.id })
  }

  # 部分一致検索をするスコープ
  scope :search_by_body, ->(query) {
    where('body LIKE ?', "%#{query}%")
  }
end
