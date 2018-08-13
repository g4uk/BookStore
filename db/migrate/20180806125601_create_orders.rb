class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.belongs_to :user, foreign_key: true
      t.decimal :total, precision: 8, scale: 2
      t.string :delivery_type
      t.decimal :delivery_price, precision: 8, scale: 2
      t.string :delivery_duration
      t.string :coupon_code
      t.belongs_to :status, index: true
      t.belongs_to :delivery, index: true

      t.timestamps
    end
  end
end
