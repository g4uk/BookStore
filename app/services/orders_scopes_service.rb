class OrdersScopesService
  class << self
    def call
      { all: Order.paid,
        in_progress: Order.in_progress,
        in_delivery: Order.in_delivery,
        delivered: Order.delivered,
        canceled: Order.canceled }
    end
  end
end
