# frozen_string_literal: true

class ConfirmOrderService
  def initialize(user:, order:)
    @email = user.email
    @order = order
  end

  def call
    if @order.may_confirm?
      @order.confirm!
      send_email
    end
  end

  private

  def send_email
    ApplicationMailer.order_email(@email, @order.id).deliver
  end
end
