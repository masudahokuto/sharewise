class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images  # 複数画像
end
