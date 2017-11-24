module AirTasker  
  class Middleware

    def initialize(app)
      @app = app 
    end 

    def call(env) 
      begin
        Rails.logger.debug "Using middleware" # Only logging for this tech test to help show which is being used
        #Wrap the request to be able to get to the query string parameters
        request = Rack::Request.new(env)
        api_token = ApiToken.new token: request.params['api_key']

        # Get the requested CacheLayer dependency for injection to the Throttler
        cache_layer = Rails.configuration.x.injection.cache_layer.new api_token
        request_allowed = AirTasker::Throttler.ValidateRequestCount cache_layer

        # Error early if request invalid, otherwise continue
        request_allowed ? @app.call(env) : [429, {'Content-Type' => 'text/plain'},["Rate limit exceeded. Try again in #{cache_layer.token_ttl} seconds"]]
        
      rescue => ex 
        # This should log to a logging steam
        Rails.logger.debug "AirTasker::Middleware Error  #{ex}"
        @app.call env
      end
    end 

  end
end
