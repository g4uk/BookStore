# frozen_string_literal: true

class AddPolymorphicToOrderItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :order_items, :order_id, :integer
    remove_column :order_items, :cart_id, :integer

    add_column :order_items, :itemable_id, :integer
    add_column :order_items, :itemable_type, :string

    add_index :order_items, %i[itemable_id itemable_type]
  end
end
