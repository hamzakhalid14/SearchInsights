# config/routes.rb
Rails.application.routes.draw do
  # Page d'accueil avec dashboard
  root 'home#index'
  get '/dashboard', to: 'home#index', as: 'dashboard'

  # API Routes seulement
  namespace :api do
    namespace :v1 do
      post 'search', to: 'searches#track'
      get 'analytics', to: 'searches#analytics'
      get 'user_analytics', to: 'searches#user_analytics'
    end
  end

  # Pour le monitoring Sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Gestion du favicon pour éviter les erreurs 404
  get '/favicon.ico', to: proc { [204, {}, []] }
end
