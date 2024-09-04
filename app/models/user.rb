class User < ApplicationRecord
  # Deviseモジュールの設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Genderのenum設定
  enum gender: { male: 0, female: 1, other: 2 }

  # バリデーション設定
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :nick_name, presence: true, length: { maximum: 50 }
  validates :profile, length: { maximum: 100 }
  validates :gender, presence: true, inclusion: { in: genders.keys }
  validates :birthday, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # ActiveStorageの設定（画像1つ）
  has_one_attached :profile_image
end
