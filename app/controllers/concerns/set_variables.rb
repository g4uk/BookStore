module SetVariables
  extend ActiveSupport::Concern

  private

  def set_categories
    @categories_for_menu = Category.all.order(:name)
  end
end
