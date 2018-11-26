# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksAuthor, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:book) }
    it { is_expected.to validate_presence_of(:author) }
  end
  context 'relations' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:author) }
  end
  context 'attributes' do
    it { is_expected.to have_db_column(:book_id).of_type(:integer) }
    it { is_expected.to have_db_column(:author_id).of_type(:integer) }
  end
end
