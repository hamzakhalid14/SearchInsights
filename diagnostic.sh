#!/bin/bash

echo "=== Diagnostic SearchInsights ==="
echo "Environment: $RAILS_ENV"
echo "Ruby version: $(ruby -v)"
echo "Rails version: $(bundle exec rails -v)"
echo "Bundle check:"
bundle check

echo -e "\n=== Configuration Files ==="
echo "Database config exists: $(test -f config/database.yml && echo 'YES' || echo 'NO')"
echo "Production config exists: $(test -f config/environments/production.rb && echo 'YES' || echo 'NO')"
echo "Gemfile.lock exists: $(test -f Gemfile.lock && echo 'YES' || echo 'NO')"

echo -e "\n=== Environment Variables ==="
echo "DATABASE_URL: ${DATABASE_URL:-'NOT SET'}"
echo "RAILS_ENV: ${RAILS_ENV:-'NOT SET'}"
echo "SECRET_KEY_BASE: $(test -n "$SECRET_KEY_BASE" && echo 'SET' || echo 'NOT SET')"

echo -e "\n=== Testing basic Rails load ==="
RAILS_ENV=production bundle exec ruby -e "
require_relative 'config/environment'
puts 'Rails application loaded successfully!'
puts 'Database connection: ' + (ActiveRecord::Base.connection.active? ? 'OK' : 'FAILED')
" 2>&1
