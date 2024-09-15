class Genre < ApplicationRecord
  belongs_to :title
  has_many :contents

  validates :title_id, presence: true
  validates :genre_name, presence: true, uniqueness: { scope: :title_id }, length: { maximum: 20 }

  # 五十音順
  def self.sort_genres(sort_order)
    if sort_order == 'alphabetical'
      if connection.adapter_name == 'SQLite'
        # SQLite用のSQL
        order(Arel.sql("CASE
          WHEN substr(genre_name, 1, 1) GLOB '[0-9０-９]*' THEN 1
          WHEN substr(genre_name, 1, 1) GLOB '[a-z]*' THEN 2
          WHEN substr(genre_name, 1, 1) GLOB '[ａ-ｚ]*' THEN 3
          WHEN substr(genre_name, 1, 1) GLOB '[A-Z]*' THEN 4
          WHEN substr(genre_name, 1, 1) GLOB '[Ａ-Ｚ]*' THEN 5
          WHEN substr(genre_name, 1, 1) GLOB '[ｱ-ﾝ]*' THEN 6
          WHEN substr(genre_name, 1, 1) GLOB '[ァ-ン]*' THEN 7
          WHEN substr(genre_name, 1, 1) GLOB '[ぁ-ん]*' THEN 8
          WHEN substr(genre_name, 1, 1) GLOB '[一-龥]*' THEN 9
          ELSE 5
        END, genre_name"))
      else
        # MySQL用のSQL
        order(Arel.sql("CASE
          WHEN genre_name REGEXP '^[0-9０-９]' THEN 1
          WHEN genre_name REGEXP '^[a-z]' THEN 2
          WHEN genre_name REGEXP '^[ａ-ｚ]' THEN 3
          WHEN genre_name REGEXP '^[A-Z]' THEN 4
          WHEN genre_name REGEXP '^[Ａ-Ｚ]' THEN 5
          WHEN genre_name REGEXP '^[ｱ-ﾝ]' THEN 6
          WHEN genre_name REGEXP '^[ァ-ン]' THEN 7
          WHEN genre_name REGEXP '^[ぁ-ん]' THEN 8
          WHEN genre_name REGEXP '^[一-龥]' THEN 9
          ELSE 5
        END, genre_name"))
      end
    else
      order(:created_at)
    end
  end
end
