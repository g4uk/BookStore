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
    @item.total = CartUtilsService.item_total_price(@item)
  end
end
