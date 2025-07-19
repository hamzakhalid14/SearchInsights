# spec/jobs/search_tracking_job_spec.rb
require 'rails_helper'

RSpec.describe SearchTrackingJob, type: :job do
  include ActiveJob::TestHelper

  let(:user_ip) { '127.0.0.1' }
  let(:query) { 'test query' }

  describe '#perform' do
    it 'creates a new search query' do
      expect {
        SearchTrackingJob.perform_now(user_ip, query)
      }.to change(SearchQuery, :count).by(1)
    end

    context 'with incomplete previous query' do
      before { create(:search_query, user_ip: user_ip, query_text: 'test', is_complete: false) }

      it 'updates existing query' do
        expect {
          SearchTrackingJob.perform_now(user_ip, 'test query')
        }.to change { SearchQuery.last.query_text }.to('test query')
      end
    end

    context 'with complete query' do
      it 'creates user search' do
        expect {
          SearchTrackingJob.perform_now(user_ip, 'complete test query?')
        }.to change(UserSearch, :count).by(1)
      end
    end
  end
end
