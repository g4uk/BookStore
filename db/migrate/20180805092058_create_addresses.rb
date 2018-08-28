class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :address, null: false
      t.string :country, null: false
      t.string :city, null: false
      t.string :zip, null: false
      t.string :phone, null: false
      t.string :type, null: false
      t.integer :addressable_id
      t.string :addressable_type
      t.timestamps
    end

    add_index :addresses, [:addressable_id, :addressable_type]
  end
end
