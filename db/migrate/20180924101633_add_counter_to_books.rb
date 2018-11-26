# frozen_string_literal: true

class AddCounterToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :comments_count, :integer, default: 0
  end
end
