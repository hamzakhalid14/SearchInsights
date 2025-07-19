# app/controllers/api/v1/searches_controller.rb
module Api
  module V1
    class SearchesController < ActionController::API
      before_action :set_user_ip

      # POST /api/v1/search
      def track
        begin
          query_text = params[:query].to_s.strip.downcase

          if query_text.present?
            # Pour le moment, créons directement sans Sidekiq pour simplifier
            SearchQuery.create!(
              user_ip: @user_ip,
              query_text: query_text,
              is_complete: false
            )

            # Mettre à jour ou créer UserSearch
            user_search = UserSearch.find_or_initialize_by(
              user_ip: @user_ip,
              final_query: query_text
            )

            if user_search.persisted?
              user_search.increment!(:search_count)
            else
              user_search.search_count = 1
              user_search.save!
            end

            render json: {
              status: 'success',
              query: query_text,
              user_ip: @user_ip
            }, status: :created
          else
            render json: {
              error: 'Query parameter is required'
            }, status: :bad_request
          end
        rescue => e
          render json: {
            error: e.message,
            status: 'failed'
          }, status: :internal_server_error
        end
      end

      # GET /api/v1/analytics
      def analytics
        begin
          # Version simplifiée pour le debugging
          total_queries = SearchQuery.count
          total_users = UserSearch.count

          top_searches = UserSearch.order(search_count: :desc)
                                  .limit(5)
                                  .pluck(:final_query, :search_count)
                                  .to_h

          render json: {
            total_queries: total_queries,
            total_users: total_users,
            top_searches: top_searches
          }
        rescue => e
          render json: {
            error: e.message,
            backtrace: e.backtrace.first(5)
          }, status: :internal_server_error
        end
      end

      # GET /api/v1/user_analytics
      def user_analytics
        begin
          user_searches = UserSearch.where(user_ip: @user_ip)
                                   .order(search_count: :desc)
                                   .limit(10)
                                   .pluck(:final_query, :search_count)

          render json: {
            user_ip: @user_ip,
            searches: user_searches
          }
        rescue => e
          render json: {
            error: e.message,
            user_ip: @user_ip
          }, status: :internal_server_error
        end
      end

      private

      def set_user_ip
        @user_ip = request.remote_ip || 'unknown_ip'
      end

      def authenticate_request
        # Simple authentification pour protéger l'API
        api_key = request.headers['X-API-KEY']
        unless api_key == ENV['API_KEY']
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end
    end
  end
end
