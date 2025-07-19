# config/initializers/rack_attack.rb
class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV['REDIS_URL'])

  # Limite à 100 requêtes par minute par IP
  throttle('req/ip', limit: 100, period: 1.minute) do |req|
    req.ip if req.path.start_with?('/api/v1')
  end

  # Limite spécifique pour le tracking de recherche
  throttle('search/ip', limit: 30, period: 10.seconds) do |req|
    req.ip if req.path == '/api/v1/search' && req.post?
  end
end
