# frozen_string_literal: true

module ActiveAdminHelpers
  def authors_with_ids(authors = Author.all)
    authors.map { |author| ["#{author.first_name} #{author.last_name}", author.id] }
  end

  def authors_list(authors)
    authors.map { |author| "#{author.first_name} #{author.last_name}" }.join(', ')
  end

  def book_image(image)
    photo = image&.photo
    photo.variant(resize: '100x100')
  end
end
