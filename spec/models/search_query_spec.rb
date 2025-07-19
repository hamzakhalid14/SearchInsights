# spec/models/search_query_spec.rb
require 'rails_helper'

RSpec.describe SearchQuery, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:user_ip) }
    it { should validate_presence_of(:query_text) }
  end

  describe '.incomplete' do
    let!(:complete) { create(:search_query, is_complete: true) }
    let!(:incomplete) { create(:search_query, is_complete: false) }

    it 'returns only incomplete queries' do
      expect(SearchQuery.incomplete).to eq([incomplete])
    end
  end
end
