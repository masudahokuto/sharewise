class Link < ApplicationRecord
  belongs_to :user
  validates :link_name, presence: true, length: { maximum: 20 }
  validates :web_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }

  # 五十音順
  def self.sort_links(sort_order)
    if sort_order == 'alphabetical'
      if connection.adapter_name == 'SQLite'
        # SQLite用のSQL
        order(Arel.sql("CASE
          WHEN substr(link_name, 1, 1) GLOB '[0-9０-９]*' THEN 1
          WHEN substr(link_name, 1, 1) GLOB '[a-z]*' THEN 2
          WHEN substr(link_name, 1, 1) GLOB '[ａ-ｚ]*' THEN 3
          WHEN substr(link_name, 1, 1) GLOB '[A-Z]*' THEN 4
          WHEN substr(link_name, 1, 1) GLOB '[Ａ-Ｚ]*' THEN 5
          WHEN substr(link_name, 1, 1) GLOB '[ｱ-ﾝ]*' THEN 6
          WHEN substr(link_name, 1, 1) GLOB '[ァ-ン]*' THEN 7
          WHEN substr(link_name, 1, 1) GLOB '[ぁ-ん]*' THEN 8
          WHEN substr(link_name, 1, 1) GLOB '[一-龥]*' THEN 9
          ELSE 5
        END, link_name"))
      else
        # MySQL用のSQL
        order(Arel.sql("CASE
          WHEN link_name REGEXP '^[0-9０-９]' THEN 1
          WHEN link_name REGEXP '^[a-z]' THEN 2
          WHEN link_name REGEXP '^[ａ-ｚ]' THEN 3
          WHEN link_name REGEXP '^[A-Z]' THEN 4
          WHEN link_name REGEXP '^[Ａ-Ｚ]' THEN 5
          WHEN link_name REGEXP '^[ｱ-ﾝ]' THEN 6
          WHEN link_name REGEXP '^[ァ-ン]' THEN 7
          WHEN link_name REGEXP '^[ぁ-ん]' THEN 8
          WHEN link_name REGEXP '^[一-龥]' THEN 9
          ELSE 5
        END, link_name"))
      end
    else
      order(:created_at)
    end
  end
end
