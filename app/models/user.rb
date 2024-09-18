class User < ApplicationRecord
  # Deviseモジュールの設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :liked_posts, through: :favorites, source: :post #Favoriteモデルを通じて関連するPostモデルのレコードを取得
  has_many :categories, dependent: :destroy
  has_many :notifications, dependent: :destroy
  # フォローフォロワーここから-----------------------------------------------------------
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :followings, -> { where(is_active: true) }, through: :relationships, source: :followed

  has_many :reverse_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, -> { where(is_active: true) }, through: :reverse_relationships, source: :follower

  # # 指定したユーザーをフォローするメソッド
  def follow(user)
    relationships.find_or_create_by(followed_id: user.id)
  end
  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    relationships.find_by(followed_id: user.id)&.destroy
  end
  # 指定したユーザーをフォローしているかどうかを判定 (退会していないユーザーのみ)
  def following?(user)
    relationships.pluck(:followed_id).include?(user.id)
  end
  # フォローフォロワーここまで-----------------------------------------------------------

  # Genderのenum設定
  enum gender: { male: 0, female: 1, other: 2 }

  # バリデーション設定
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :nick_name, presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 40 }
  validates :gender, presence: true, inclusion: { in: genders.keys }
  validates :birthday, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # ActiveStorageの設定（画像1つ）
  has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # ユーザーの最新の投稿を取得
  def recent_post
    posts.order(created_at: :desc).first
  end

  # 年齢を計算するメソッド
  def age
    return if birthday.nil?
    today = Date.today
    age = today.year - birthday.year
    age -= 1 if today < birthday + age.years # 誕生日がまだ来ていない場合は1歳引く
    age
  end

  def favorite(post)
    self.favorites.find_or_create_by(post_id: post.id)
  end

  # ユーザーが特定のポストをいいねしているかを判定
  def favorited_by?(post)
    favorites.exists?(post_id: post.id)
  end

  def full_name
    "#{last_name} #{first_name}"
  end

  # user検索機能　部分一致のみ
  scope :search, -> (query) {
    where('nick_name LIKE ?', "%#{query}%")
  }
end
