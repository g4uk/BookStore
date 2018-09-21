class CreditCardNumberService
  class << self
    def call(order_params)
      order_params[:credit_card_attributes][:number].last(4)
    end
  end
end