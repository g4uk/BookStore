class CheckoutStepService < Rectify::Command
  STATUSES = { address: :address,
               shipping: :delivery,
               in_progress: :payment,
               payment: :confirm }.freeze

  def initialize(order:, step:)
    @order = order
    @step = step
  end

  def call
    current_step = STATUSES[@order.status.to_sym]
    return broadcast(:ok, current_step) unless @order.payment? || current_step == @step
  end
end
