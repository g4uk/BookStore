class Image < ApplicationRecord
  belongs_to :book
  has_one_attached :photo, dependent: :destroy

  validates :photo, file_size: { less_than: 5.megabytes },
                    file_content_type: { allow: ['image/jpeg', 'image/png'] }
end
