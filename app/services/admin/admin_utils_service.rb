class Admin::AdminUtilsService
  class << self
    def authors_with_ids(authors = Author.all)
      authors.map { |author| ["#{author.first_name} #{author.last_name}", author.id] }
    end

    def authors_links(authors)
      authors.map { |author| "#{author.first_name} #{author.last_name}" }.join(', ')
    end

    def book_image(image)
      image.variant(resize: '100x100')
    end
  end
end
