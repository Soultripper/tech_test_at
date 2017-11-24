module AirTasker
  class RedisCacheLayer

    attr_accessor :api_token

    delegate :token, :interval, :requests_allowed, to: :api_token

    def initialize(api_token)
      @api_token = api_token
    end

    def request_count
      ($redis.get token).to_i
    end

    def incr_request_count
      ($redis.incr token).to_i
    end

    def set_token_ttl
      $redis.expire token, interval
    end

    def token_ttl
      $redis.ttl token
    end

    def count_within_limit? 
      request_count < requests_allowed
    end
    
    def to_s
      "Token=#{token}, TTL=#{token_ttl}, RequestsAllowed=#{requests_allowed}, Interval=#{interval}, Count=#{request_count}"
    end
  end
end
