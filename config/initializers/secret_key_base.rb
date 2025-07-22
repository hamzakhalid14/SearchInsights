# config/initializers/secret_key_base.rb
Rails.application.configure do
  # Generate a secret key if not provided in environment
  if Rails.env.production? && ENV['SECRET_KEY_BASE'].blank?
    # Generate a simple secret key for Railway deployment
    config.secret_key_base = Digest::SHA256.hexdigest("#{Rails.application.class.name}-production-secret")
  end
end
