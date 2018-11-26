# frozen_string_literal: true

class AddCouponToCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :carts, :coupon_code, :string
    add_column :carts, :coupon_price, :decimal, precision: 8, scale: 2
  end
end
