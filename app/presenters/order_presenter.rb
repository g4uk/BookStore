class OrderPresenter < BasePresenter
  def initialize(order)
    @order = order
  end

  def order_items
    @order.order_items
  end

  def billing_address
    AddressDecorator.decorate(@order.billing_address)
  end

  def shipping_address
    AddressDecorator.decorate(@order.shipping_address)
  end

  def deliveries
    Delivery.all.decorate
  end
end
