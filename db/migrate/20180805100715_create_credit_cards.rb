# frozen_string_literal: true

class CreateCreditCards < ActiveRecord::Migration[5.2]
  def change
    create_table :credit_cards do |t|
      t.string :number, null: false
      t.belongs_to :order, index: true

      t.timestamps
    end
  end
end
