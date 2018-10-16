class FillAddressesService
  def initialize(order:, order_params:)
    @order = order
    @order_params = order_params
    @billing_flag = order_params[:billing_flag].eql?('1')
  end

  def call
    @order.assign_attributes(@order_params)
    assign_shipping_address
    @order.fill_address! if @order.may_fill_address? && @order.save
  end

  private

  def assign_shipping_address
    @order.shipping_address.assign_attributes(@order_params[:billing_address_attributes]) if @billing_flag
  end
end
