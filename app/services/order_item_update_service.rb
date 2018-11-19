# frozen_string_literal: true

class OrderItemUpdateService < Rectify::Command
  def initialize(item)
    @item = item
  end

  def call
    recalculate_total
    return broadcast(:ok, @item) if @item.save
  end

  private

  def recalculate_total
    @item.total = @item.book_price * @item.quantity
  end
end
