class Content < ApplicationRecord
  belongs_to :genre
  has_many_attached :images

  validates :genre_id, presence: true
  validates :content_name, presence: true, uniqueness: { scope: :genre_id }, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 5000 }
  # 許可するファイル形式を設定
  validates :images, content_type: { in: ['image/jpg', 'image/jpeg', 'image/png'] }
  # 画像のサイズを制限 (例: 5MB 以下)
  validates :images, size: { less_than: 5.megabytes }
  # 画像3枚まで
  def image_length
    if images.length >= 4
      errors.add(:images, "は3枚以内にしてください")
    end
  end
  
  # 五十音順
  def self.sort_contents(sort_order)
    if sort_order == 'alphabetical'
      if connection.adapter_name == 'SQLite'
        # SQLite用のSQL
        order(Arel.sql("CASE
          WHEN substr(content_name, 1, 1) GLOB '[0-9０-９]*' THEN 1
          WHEN substr(content_name, 1, 1) GLOB '[a-z]*' THEN 2
          WHEN substr(content_name, 1, 1) GLOB '[ａ-ｚ]*' THEN 3
          WHEN substr(content_name, 1, 1) GLOB '[A-Z]*' THEN 4
          WHEN substr(content_name, 1, 1) GLOB '[Ａ-Ｚ]*' THEN 5
          WHEN substr(content_name, 1, 1) GLOB '[ｱ-ﾝ]*' THEN 6
          WHEN substr(content_name, 1, 1) GLOB '[ァ-ン]*' THEN 7
          WHEN substr(content_name, 1, 1) GLOB '[ぁ-ん]*' THEN 8
          WHEN substr(content_name, 1, 1) GLOB '[一-龥]*' THEN 9
          ELSE 5
        END, content_name"))
      else
        # MySQL用のSQL
        order(Arel.sql("CASE
          WHEN content_name REGEXP '^[0-9０-９]' THEN 1
          WHEN content_name REGEXP '^[a-z]' THEN 2
          WHEN content_name REGEXP '^[ａ-ｚ]' THEN 3
          WHEN content_name REGEXP '^[A-Z]' THEN 4
          WHEN content_name REGEXP '^[Ａ-Ｚ]' THEN 5
          WHEN content_name REGEXP '^[ｱ-ﾝ]' THEN 6
          WHEN content_name REGEXP '^[ァ-ン]' THEN 7
          WHEN content_name REGEXP '^[ぁ-ん]' THEN 8
          WHEN content_name REGEXP '^[一-龥]' THEN 9
          ELSE 5
        END, content_name"))
      end
    else
      order(:created_at)
    end
  end
end
