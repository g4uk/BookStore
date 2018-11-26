# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  context 'relations' do
    it { is_expected.to belong_to(:resource) }
  end

  context 'attributes' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:resource_id).of_type(:integer) }
    it { is_expected.to have_db_column(:resource_type).of_type(:string) }
  end
end
