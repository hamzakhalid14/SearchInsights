# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Données de test pour SearchInsights
puts "Création de données de test..."

# Vider les données existantes
SearchQuery.delete_all
UserSearch.delete_all

# Créer des recherches d'exemple
sample_queries = [
  "comment apprendre le ruby",
  "tutoriel rails",
  "installation postgresql",
  "déploiement application web",
  "optimisation base de données",
  "sécurité web application",
  "test unitaire rspec",
  "api rest rails",
  "authentification utilisateur",
  "cache redis performance"
]

sample_ips = [
  "192.168.1.100",
  "192.168.1.101",
  "192.168.1.102",
  "10.0.0.50",
  "10.0.0.51"
]

# Créer des SearchQuery
20.times do |i|
  SearchQuery.create!(
    user_ip: sample_ips.sample,
    query_text: sample_queries.sample,
    is_complete: [true, false].sample,
    created_at: rand(7.days).seconds.ago
  )
end

# Créer des UserSearch (recherches finales agrégées)
sample_queries.each_with_index do |query, index|
  UserSearch.create!(
    user_ip: sample_ips[index % sample_ips.length],
    final_query: query,
    search_count: rand(1..15),
    created_at: rand(7.days).seconds.ago
  )
end

puts "✅ #{SearchQuery.count} recherches créées"
puts "✅ #{UserSearch.count} utilisateurs avec recherches finales créés"
puts "Données de test générées avec succès!"
