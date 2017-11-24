

  # Using FactoryBot - PITA because my model takes args in the constructor: https://robots.thoughtbot.com/factory-girl-2-5-gets-custom-constructors 

  # This will guess the User class
FactoryBot.define do
  factory :default_user_token, class: AirTasker::ApiToken do
    initialize_with { new(properties) }    
    properties token:'default_user_token', interval: 10, requests_allowed: 5    
  end

  factory :one_request_every_second, class: AirTasker::ApiToken do
    initialize_with { new(properties) }    
    properties token:'one_request_every_second', interval: 1, requests_allowed: 1  
  end

  factory :one_request_every_five_seconds, class: AirTasker::ApiToken do
    initialize_with { new(properties) }    
    properties token:'one_request_every_five_seconds', interval: 5, requests_allowed: 1  
  end


end