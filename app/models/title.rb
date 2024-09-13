class Title < ApplicationRecord
  belongs_to :category
  has_many :genres

  validates :category_id, presence: true
  validates :title_name, presence: true, uniqueness: { scope: :category_id }, length: { maximum: 20 }
end
