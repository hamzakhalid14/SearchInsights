# config/initializers/sidekiq.rb
if ENV['REDIS_URL'].present?
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end
else
  # Désactiver Sidekiq si Redis n'est pas disponible
  Rails.logger.info "Redis URL not configured, Sidekiq will be disabled"
end
