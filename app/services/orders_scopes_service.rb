class OrdersScopesService
  class << self
    def call(user)
      { all: user.orders.paid,
        in_progress: user.orders.in_progress,
        in_delivery: user.orders.in_delivery,
        delivered: user.orders.delivered,
        canceled: user.orders.canceled }
    end
  end
end
