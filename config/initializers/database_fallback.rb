# config/initializers/database_fallback.rb
begin
  # Test database connection at startup
  ActiveRecord::Base.connection.execute("SELECT 1")
  Rails.logger.info "Database connection successful"
rescue => e
  Rails.logger.error "Database connection failed: #{e.message}"
  # Continue anyway to allow the app to start
end
