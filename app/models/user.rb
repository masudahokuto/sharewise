class User < ApplicationRecord
  # Deviseモジュールの設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :liked_posts, through: :favorites, source: :post
  has_many :categories, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one_attached :profile_image

  # フォロー・フォロワー関連
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :followings, -> { where(is_active: true) }, through: :relationships, source: :followed
  has_many :reverse_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, -> { where(is_active: true) }, through: :reverse_relationships, source: :follower

  # Genderのenum設定
  enum gender: { male: 0, female: 1, other: 2 }

  # バリデーション
  validates :last_name, :first_name, :nick_name, presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 40 }
  validates :gender, presence: true, inclusion: { in: genders.keys }
  validates :birthday, :email, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :profile_image, content_type: { in: ['image/jpg', 'image/jpeg', 'image/png'] }, size: { less_than: 5.megabytes }

  # フォローメソッド
  def follow(user)
    relationships.find_or_create_by(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id)&.destroy
  end

  def following?(user)
    relationships.pluck(:followed_id).include?(user.id)
  end

  # プロフィール画像の取得
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # ユーティリティメソッド
  def recent_post
    posts.order(created_at: :desc).first
  end

  def age
    return if birthday.nil?
    today = Date.today
    age = today.year - birthday.year
    age -= 1 if today < birthday + age.years
    age
  end

  def full_name
    "#{last_name} #{first_name}"
  end

  def favorite(post)
    favorites.find_or_create_by(post_id: post.id)
  end

  def favorited_by?(post)
    favorites.exists?(post_id: post.id)
  end

  # スコープ
  scope :search, -> (query) {
    where('nick_name LIKE ?', "%#{query}%")
  }

  scope :search_by, -> (field, query) {
    if field == 'id'
      where('id LIKE ?', "%#{query}%")
    else
      where("#{field} LIKE ?", "%#{query}%")
    end
  }

  scope :active_users, ->(current_user) {
    where(is_active: true).where.not(id: current_user&.id)
  }

  scope :order_by_recent, -> {
    order(created_at: :desc)
  }
end
