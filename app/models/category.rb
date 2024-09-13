class Category < ApplicationRecord
  belongs_to :user
  has_many :title
  validates :user_id, presence: true
  validates :category_name, presence: true, uniqueness: { scope: :user_id }, length: { maximum: 20 }
end
