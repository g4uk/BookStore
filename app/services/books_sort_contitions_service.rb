class BooksSortContitionsService
  class << self
    def call
      ['created_at desc',
       'popular',
       'price asc',
       'price desc',
       'title asc',
       'title desc']
    end
  end
end