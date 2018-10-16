class CartsCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Cart.weeks_old.destroy_all
  end
end
