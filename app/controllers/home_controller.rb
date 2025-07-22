# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    # Render the dashboard view
    render json: { status: 'ok', message: 'SearchInsights API is running' }
  end
end
