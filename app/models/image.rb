class Image < ApplicationRecord
  belongs_to :book
  has_many_attached :images, dependent: :destroy

  validates :images, file_size: { less_than: 5.megabytes },
                     file_content_type: { allow: ['image/jpeg', 'image/png'] }
end
