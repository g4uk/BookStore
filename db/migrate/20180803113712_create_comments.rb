class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :title, null: false
      t.integer :rating, null: false, default: 0
      t.text :text, null: false
      t.integer :status, null: false, default: 0
      t.belongs_to :user, foreign_key: true
      t.belongs_to :book, foreign_key: true

      t.timestamps
    end
  end
end
