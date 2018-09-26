class PaymentService
  class << self
    def call(order:, order_params:, cart:)
      order.assign_attributes(order_params)
      order.credit_card.number = order_params[:credit_card_attributes][:number].last(4)
      if order.may_fill_payment? && order.save
        cart.destroy
        order.fill_payment!
      end
      order
    end
  end
end
