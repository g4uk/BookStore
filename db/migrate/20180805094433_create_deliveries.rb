class CreateDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :deliveries do |t|
      t.string :name, null: false
      t.string :duration, null: false
      t.decimal :price, precision: 6, scale: 2

      t.timestamps
    end
  end
end
