# frozen_string_literal: true

class AddCounterToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :books_count, :integer, default: 0
  end
end
