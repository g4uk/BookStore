class CreateCreditCards < ActiveRecord::Migration[5.2]
  def change
    create_table :credit_cards do |t|
      t.string :number, null: false
      t.string :owner_name, null: false
      t.string :expiration_date, null: false
      t.belongs_to :order, index: true

      t.timestamps
    end
  end
end
