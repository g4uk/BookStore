# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.belongs_to :category, index: true
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.integer :publishing_year, null: false, default: Date.today.year
      t.text :dimensions
      t.string :materials

      t.timestamps
    end
  end
end
