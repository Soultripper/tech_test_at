module AirTasker
  class ApiToken

    RATE_INTERVAL = ENV['API_RATE_INTERVAL'].to_i || 216000
    RATE_COUNT = ENV['API_RATE_COUNT'].to_i || 1000

    attr_accessor :token, :requests_allowed, :interval
    
    def initialize(properties)
      @token = properties[:token]
      @requests_allowed = properties[:requests_allowed] || RATE_COUNT  
      @interval = properties[:interval] || RATE_INTERVAL

      #Can add additional properties here, such as whitelisted, blacklisted
      #@whitelisted = properties[:whitelisted]
    end

    # Very simple check for now, but should be a JWT or OAuth token, which could be checked against a database for extra security
    def valid?
      !token.blank?
    end
    
  end
end