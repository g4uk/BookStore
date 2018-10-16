class FindOrderQuery
  def initialize(order_id:, step:)
    @order_id = order_id
    @step = step
  end

  def call
    return set_order_with_items if %i[confirm complete].include?(@step)
    set_order
  end

  private

  def set_order
    Order.find_or_initialize_by(id: @order_id).decorate
  end

  def set_order_with_items
    Order.includes(order_items: [:book, image_attachment: :blob]).find(@order_id).decorate
  end
end
