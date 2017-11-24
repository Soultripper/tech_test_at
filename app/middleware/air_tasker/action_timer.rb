module AirTasker
    class ActionTimer

      def self.time &block
        start = Time.now
        result = yield block
        elapsed = Time.now - start
        Rails.logger.debug "Action Time: #{caller_locations.first} Elapsed time: #{elapsed.to_s} seconds"
        result
      end
    end
end