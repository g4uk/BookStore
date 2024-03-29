# frozen_string_literal: true

class CreateJoinTableBookAuthor < ActiveRecord::Migration[5.2]
  def change
    create_join_table :books, :authors, table_name: :books_authors do |t|
      t.column :id, :primary_key
      t.index %i[book_id author_id]
      t.index %i[author_id book_id]
    end
  end
end
