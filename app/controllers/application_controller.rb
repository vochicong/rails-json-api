# File: app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  protected

    # Snakeize JSON API request params
    def snakeize_params
      params.deep_snakeize!
    end
end
