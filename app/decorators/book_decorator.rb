class BookDecorator < Draper::Decorator
  delegate_all

  def formatted_authors
    authors.map { |author| "#{author.first_name} #{author.last_name}" }.join(', ')
  end
end
