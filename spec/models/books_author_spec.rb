# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksAuthor, type: :model do
  context 'validations' do
    it { should validate_presence_of(:book) }
    it { should validate_presence_of(:author) }
  end
  context 'relations' do
    it { should belong_to(:book) }
    it { should belong_to(:author) }
  end
  context 'attributes' do
    it { should have_db_column(:book_id).of_type(:integer) }
    it { should have_db_column(:author_id).of_type(:integer) }
  end
end
