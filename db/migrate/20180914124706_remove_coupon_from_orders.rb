# frozen_string_literal: true

class RemoveCouponFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :coupon_code, :string
    remove_column :orders, :coupon_price, :decimal, precision: 8, scale: 2
  end
end
