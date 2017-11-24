
require 'test_helper'

# The tests below are just an example of using factories and a mock caching layer
# My own admission, they are quite redundant as the testing should be on the AirTasker::Throttler 
# There's some self-debate as to where to apply the business logic. The Throttler or on the token

class MockCacheLayerTest < ActiveSupport::TestCase
  
  test "can increment the request count" do

    cache_mock = cache_layer :default_user_token
    
    assert cache_mock.request_count == 0
    cache_mock.incr_request_count
    assert cache_mock.request_count == 1

  end

  test "the count limit has been reached" do  

    cache_mock = cache_layer :default_user_token
    cache_mock.count = cache_mock.requests_allowed

    assert cache_mock.request_count == cache_mock.requests_allowed
    assert !cache_mock.count_within_limit?

  end

  test "token cache expires" do    
      cache_mock = cache_layer :one_request_every_second
      cache_mock.set_token_ttl
      assert cache_mock.token_ttl > 0 
      sleep 1
      assert cache_mock.token_ttl.nil? || cache_mock.token_ttl <= 0
  end

  def cache_layer(factory)
    Rails.configuration.x.injection.cache_layer.new build(factory)
  end
end