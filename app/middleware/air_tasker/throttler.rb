module AirTasker

  class Throttler

    def self.ValidateRequestCount(cache_layer)

      callee = "AirTasker::Throttler.#{__callee__}"

      begin

        # Normally would use 3rd party log like Log4Net / Papertrail
        Rails.logger.debug "#{callee} | Checking throttle for #{cache_layer.to_s}"

        # Update the requests count first, then check to see if it requires resetting. This saves us round trip
        cur_count = cache_layer.incr_request_count 
        
        # If this is the first request, reset the cache expiry for this api request
        cache_layer.set_token_ttl if cur_count == 1
          
        # finally, return true if no. of requests made are within the threshold, else false
        cur_count < cache_layer.requests_allowed
      rescue => ex
        Rails.logger.error "#{callee} | #{ex}"
        true #assume on error, requests will still succeed as not users fault. Important to check logs for errors
      end
    end
  end
end