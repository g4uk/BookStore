# frozen_string_literal: true

class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.belongs_to :book, foreign_key: true
      t.belongs_to :cart, foreign_key: true
      t.belongs_to :order, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.string :book_name
      t.decimal :book_price, precision: 8, scale: 2
      t.decimal :total, precision: 8, scale: 2

      t.timestamps
    end
  end
end
