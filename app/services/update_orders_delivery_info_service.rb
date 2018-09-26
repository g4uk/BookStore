class UpdateOrdersDeliveryInfoService
  class << self
    def call(order:, order_params:)
      delivery_id = order_params[:delivery_id]
      delivery = Delivery.find(delivery_id)
      updated_order = order.update_attributes(delivery_id: delivery.id,
                                              delivery_type: delivery.name,
                                              delivery_price: delivery.price,
                                              delivery_duration: delivery.duration)
      order.fill_delivery! if order.may_fill_delivery? && updated_order
    end
  end
end
