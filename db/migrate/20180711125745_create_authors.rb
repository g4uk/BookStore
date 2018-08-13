# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :authors do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.text :description

      t.timestamps
    end
  end
end
