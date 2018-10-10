class FillAddressesService
  class << self
    def call(order:, order_params:)
      order.assign_attributes(order_params)
      order.shipping_address.assign_attributes(order_params[:billing_address_attributes]) if order_params[:billing_flag].eql?('1')
      order.fill_address! if order.may_fill_address? && order.save
    end
  end
end
