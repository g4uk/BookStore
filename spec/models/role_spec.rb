require 'rails_helper'

RSpec.describe Role, type: :model do
  context 'relations' do
    it { should belong_to(:resource) }
  end

  context 'attributes' do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:resource_id).of_type(:integer) }
    it { should have_db_column(:resource_type).of_type(:string) }
  end
end
