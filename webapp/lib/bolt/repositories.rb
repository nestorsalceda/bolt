module Bolt
  class TemperatureRepository
    def initialize(redis_client)
      @redis = redis_client
    end

    def store(timestamp, temperature)
      @redis.zadd(:temperatures, timestamp, temperature)
    end
  end
end
