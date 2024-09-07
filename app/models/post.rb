class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images  # 複数画像
  validates :body, presence: true
  validate :images_format
  validate :image_length
  private

  def images_format
    if images.attached?
      images.each do |image|
        unless image.content_type.in?(%('image/jpeg image/png'))
          errors.add(:images, 'にはJPEGまたはPNGの画像ファイルを指定してください。')
        end
      end
    end
  end

  def image_length
    if images.length >= 4
      errors.add(:images, "は3枚以内にしてください")
    end
  end
end
