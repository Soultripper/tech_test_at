class HomeController < ApplicationController

  before_action :throttle_filter, only: :index, unless: -> {using_middleware?}

  def index
    # Custom timer to demonstrate use of blocks, though requests should be monitored (if not using something like NewRelic)
    AirTasker::ActionTimer.time do 
      # Ensure request is valid token
      return render plain: "Usage requires 'api_key' query string parameter", status: 401 if !api_token.valid?
      render plain: "ok"
    end

  end

  def stats 
    render plain: cache_layer.to_s
  end
  protected

  def throttle_filter   
    logger.debug "Using before_action filter" # Only logging for this tech test to help show which is being used     
    @request_allowed = AirTasker::Throttler.ValidateRequestCount cache_layer   # Register API Request
    render plain: "Rate limit exceeded. Try again in #{cache_layer.token_ttl} seconds", status: 429 if !@request_allowed 
    @request_allowed
  end

  def cache_layer
    # Retrieve dependency injected cache layer
    @cache_layer ||= Rails.configuration.x.injection.cache_layer.new api_token
  end

  def api_token
    @api_token ||= AirTasker::ApiToken.new token: params[:api_key]
  end

  def using_middleware?
    # Not happy with this as it feels like a hack. 
    # It hurts performance and therefore should probably be just a boolean config value in the setup
    # But hardly shown any use of array methods in this code test, so just another exmaple ;)
    # I've put logic here, but shouldn't be in the controller
    Rails.configuration.middleware.any? {|mw| mw.name == "AirTasker::Middleware" }
  end

end
