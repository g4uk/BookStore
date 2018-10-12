class SortPresenter < BasePresenter
  SORT_CONDITIONS = ['created_at desc',
                     'popular',
                     'price asc',
                     'price desc',
                     'title asc',
                     'title desc'].freeze

  attr_reader :sort_param, :category_id, :sort_conditions

  def initialize(sort_param:, category_id:)
    @sort_param = sort_param || SORT_CONDITIONS.first
    @category_id = category_id
    @sort_conditions = SORT_CONDITIONS
  end
end
