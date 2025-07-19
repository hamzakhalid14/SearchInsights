# spec/requests/searches_spec.rb
require 'rails_helper'

RSpec.describe 'Searches API', type: :request do
  let(:valid_headers) { { 'X-API-KEY' => 'test_key' } }
  before { ENV['API_KEY'] = 'test_key' }

  describe 'POST /api/v1/search' do
    context 'with valid parameters' do
      it 'returns accepted status' do
        post '/api/v1/search', params: { query: 'test' }, headers: valid_headers
        expect(response).to have_http_status(:accepted)
      end
    end
  end

  describe 'GET /api/v1/analytics' do
    before { create_list(:user_search, 3) }

    it 'returns top searches' do
      get '/api/v1/analytics', headers: valid_headers
      expect(response).to have_http_status(:ok)
      expect(json_response['top_searches']).not_to be_empty
    end
  end
end
