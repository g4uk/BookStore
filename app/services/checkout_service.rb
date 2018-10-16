class CheckoutService
  def initialize(options = {})
    options.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def call
    fill_address
    copy_delivery_info
    fill_payment_info
    @order
  end

  private

  def fill_address
    FillAddressesService.new(order: @order, order_params: @params).call if @step.eql?(:address)
  end

  def copy_delivery_info
    UpdateOrdersDeliveryInfoService.new(order: @order, order_params: @params).call if @step.eql?(:delivery)
  end

  def fill_payment_info
    PaymentService.new(order: @order, order_params: @params, cart: @cart).call if @step.eql?(:payment)
  end
end
