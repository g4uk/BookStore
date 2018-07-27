# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.belongs_to :category
      t.text :description
      t.decimal :price, precision: 6, scale: 2

      t.timestamps
    end
  end
end
