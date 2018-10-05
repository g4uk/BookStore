class CartsCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Cart.where(['created_at < ?', Time.now.midnight - 7.days]).destroy_all
  end
end
