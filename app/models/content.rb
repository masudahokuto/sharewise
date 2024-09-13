class Content < ApplicationRecord
  belongs_to :genre
  has_many_attached :images

  validates :genre_id, presence: true
  validates :content_name, presence: true, uniqueness: { scope: :genre_id }, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 5000 }
end
