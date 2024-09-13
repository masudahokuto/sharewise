class Genre < ApplicationRecord
  belongs_to :title
  has_many :contents

  validates :title_id, presence: true
  validates :genre_name, presence: true, uniqueness: { scope: :title_id }, length: { maximum: 20 }
end
