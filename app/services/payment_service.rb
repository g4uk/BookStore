class PaymentService
  def initialize(order:, order_params:, cart:)
    @order = order
    @card_number = order_params[:credit_card_attributes][:number].last(4)
  end

  def call
    add_card
    purchase if @order.may_fill_payment? && @order.save
    @order.save
  end

  private

  def add_card
    @order.build_credit_card.number = @card_number
  end

  def purchase
    @order.fill_payment!
    @cart.destroy
  end
end
