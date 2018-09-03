class LatestBooksService
  class << self
    def call
      latest_books = Book.all.order('created_at desc').limit(3)
      BookDecorator.decorate_collection(latest_books)
    end
  end
end
