# Technical Test Instructions

This reppository contains a docker compose file to help set up the product quickly

Download the repo, and then run

**docker-compose up --build**

To run the tests

**docker-compose run web rails test test/models/mock_cache_layer_test.rb**

If all goes to plan, docker will pull the latest rails and redis images, then run the bundler and start the application  in production mode. Remove **-e production** from the **docker-compose.yml** file to start in Development mode (can stop with **docker-compose down**). 

Note: If it says server is already running, can remove the PID with **docker-compose run web rm /app/tmp/pids/server.pid**

The application has several key facets

* Production mode utilises a rack middleware implementation of the rate throttler
* Development mode utilises a **before_filter** action on the controller
* It uses Redis for centralised caching, making use of the TTL property on a key
* There is basic Dependency Injection / IoC. The caching layer, that handles the storage of the request count for a token is defined in the environment file. There are two types of cache layers, **RedisCacheLayer** and **MockCacheLayer**. The latter isn't complete as was getting out of scope for this test but is used in the tests. It would be trivial to implement a **SqlCacheLayer**
* Requests require a simple query string parameter of api_key. This is much more akin to a real life example. 
* Whilst there is no relational database / ActiveRecord models, the class **ApiToken** is designed to map to a table that associated a user / api key with properties. The idea that each user can have their own rates / intervals assigned rather than a simple site wide configuration
* The logging is using the default Rails.logger, rather than a 3rd party which are trivial to setup but require normally an account on their services e.g. Papertrail, which is the recommended process
* The tests are very basic due to time constraints, and really to show examples of fixtures / mocks
* The tokens can be any value, however it was hoped I would have time to use JWTs, even perhaps utilise a 3rd party like Auth0, but was felt this was out of scope.


Main things to note, is that the core of the codebase is in **/app/middleware**. This isn't the best folder naming, and if given time, would move into a gem and **/lib/** folders

Redis is configured as a global **/config/initializers/redis.rb**

I have used **dotenv** plugin to make it easy to map to ENV variables in the application. For the purposes of this test, I have set it to be used in  production. Normally these reside on securely on the server or are pulled in via a deployment script.

I used redis commander to view my Redis keys via a web GUI for debugging. 

Further discussion of the project is advised in person :)
