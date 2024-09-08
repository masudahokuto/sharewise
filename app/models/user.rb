class User < ApplicationRecord
  # Deviseモジュールの設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  # Genderのenum設定
  enum gender: { male: 0, female: 1, other: 2 }

  # バリデーション設定
  validates :last_name, presence: true, length: { maximum: 10 }
  validates :first_name, presence: true, length: { maximum: 10 }
  validates :nick_name, presence: true, length: { maximum: 10 }
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
end
