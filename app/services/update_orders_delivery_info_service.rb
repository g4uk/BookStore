class UpdateOrdersDeliveryInfoService
  def initialize(order:, order_params:)
    @order = order
    @delivery = Delivery.find(order_params[:delivery_id])
  end

  def call
    updated_order = update_delivery_info
    @order.fill_delivery! if @order.may_fill_delivery? && updated_order
  end

  private

  def update_delivery_info
    @order.update(delivery_id: @delivery.id,
                 delivery_type: @delivery.name,
                 delivery_price: @delivery.price,
                 delivery_duration: @delivery.duration)
  end
end
