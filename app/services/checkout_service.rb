class CheckoutService
  def initialize(options = {})
    options.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def call
    fill_address if @step.eql?(:address)
    copy_delivery_info if @step.eql?(:delivery)
    fill_payment_info if @step.eql?(:payment)
    @order
  end

  private

  def fill_address
    FillAddressesService.new(order: @order, order_params: @params).call
  end

  def copy_delivery_info
    UpdateOrdersDeliveryInfoService.new(order: @order, order_params: @params).call
  end

  def fill_payment_info
    PaymentService.new(order: @order, order_params: @params, cart: @cart).call
  end
end
