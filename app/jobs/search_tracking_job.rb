# app/jobs/search_tracking_job.rb
class SearchTrackingJob < ApplicationJob
  queue_as :default

  def perform(user_ip, query_text)
    # Logique de traitement des recherches
    handle_search_query(user_ip, query_text)
  end

  private

  def handle_search_query(user_ip, query_text)
    # Trouve la dernière recherche incomplète de l'utilisateur
    last_incomplete = SearchQuery.where(user_ip: user_ip, is_complete: false).last

    if last_incomplete && query_text.start_with?(last_incomplete.query_text)
      # Mise à jour de la recherche existante
      last_incomplete.update(query_text: query_text)
    else
      # Marque les anciennes recherches comme complètes
      SearchQuery.where(user_ip: user_ip, is_complete: false).update_all(is_complete: true)

      # Crée une nouvelle entrée
      SearchQuery.create!(user_ip: user_ip, query_text: query_text, is_complete: false)
    end

    # Vérifie si la recherche semble complète
    if query_complete?(query_text)
      finalize_search(user_ip, query_text)
    end
  end

  def query_complete?(query)
    # Heuristique pour déterminer si une recherche est complète
    query.ends_with?('?') || query.ends_with?('.') ||
    query.split.size >= 3 || query.length > 25
  end

  def finalize_search(user_ip, query_text)
    # Marque la recherche comme complète
    SearchQuery.where(user_ip: user_ip, query_text: query_text)
               .update_all(is_complete: true)

    # Enregistre la recherche finale
    UserSearch.find_or_initialize_by(user_ip: user_ip, final_query: query_text) do |search|
      search.search_count ||= 0
      search.search_count += 1
      search.save!
    end

    # Nettoie le cache
    Rails.cache.delete('top_searches')
    Rails.cache.delete("user_searches_#{user_ip}")
  end
end
