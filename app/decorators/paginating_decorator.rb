
class PaginatingDecorator < Draper::CollectionDecorator
  delegate :current_page, :total_pages, :limit_value, :entry_name, :total_count, :offset_value, :last_page?, :next_page

  def view_more_link
    if object.current_page < object.total_pages
      h.link_to I18n.t(:view_more), h.books_path(page: object.current_page + 1), id: 'load-more-posts', class: 'btn btn-primary', remote: true
    end
  end
end