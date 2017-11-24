module AirTasker
  class MockCacheLayer

    attr_accessor :api_token, :count
    delegate :token, :interval, :requests_allowed, to: :api_token

    def initialize(api_token)
      @api_token = api_token
      @count = 0
    end
  
    def request_count
      @count
    end

    def incr_request_count
      @count = @count+1
    end

    def set_token_ttl
      @expiry_time = Time.now + interval
    end

    def token_ttl
      @expiry_time - Time.now
    end

    def count_within_limit? 
      @count < requests_allowed
    end

    def to_s
      "Token=#{token}, TTL=#{token_ttl}, RequestsAllowed=#{requests_allowed}, Interval=#{interval}, Count=#{count}"
    end
    
  end
end
