class Category < ApplicationRecord
  belongs_to :user
  has_many :titles
  validates :user_id, presence: true
  validates :category_name, presence: true, uniqueness: { scope: :user_id }, length: { maximum: 20 }

  # 五十音順
  def self.sort_categories(sort_order)
    if sort_order == 'alphabetical'
      if connection.adapter_name == 'SQLite'
        # SQLite用のSQL
        order(Arel.sql("CASE
          WHEN substr(category_name, 1, 1) GLOB '[0-9０-９]*' THEN 1
          WHEN substr(category_name, 1, 1) GLOB '[a-z]*' THEN 2
          WHEN substr(category_name, 1, 1) GLOB '[ａ-ｚ]*' THEN 2
          WHEN substr(category_name, 1, 1) GLOB '[A-Z]*' THEN 3
          WHEN substr(category_name, 1, 1) GLOB '[Ａ-Ｚ]*' THEN 4
          WHEN substr(category_name, 1, 1) GLOB '[ｱ-ﾝ]*' THEN 5
          WHEN substr(category_name, 1, 1) GLOB '[ァ-ン]*' THEN 6
          WHEN substr(category_name, 1, 1) GLOB '[ぁ-ん]*' THEN 7
          WHEN substr(category_name, 1, 1) GLOB '[一-龥]*' THEN 8
          ELSE 5
        END, category_name"))
      else
        # MySQL用のSQL
        order(Arel.sql("CASE
          WHEN category_name REGEXP '^[0-9]' THEN 1
          WHEN category_name REGEXP '^[a-zA-Z]' THEN 2
          WHEN category_name REGEXP '^[ｱ-ﾝ]' THEN 3
          WHEN category_name REGEXP '^[ぁ-ん]' THEN 4
          WHEN category_name REGEXP '^[一-龥]' THEN 5
          ELSE 5
        END, category_name"))
      end
    else
      order(:created_at)
    end
  end
end
