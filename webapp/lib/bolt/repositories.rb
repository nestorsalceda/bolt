module Bolt
  class TemperatureRepository
    def initialize(redis_client)
      @redis = redis_client
    end

    def store(timestamp, temperature)
      unix_timestamp = timestamp.to_i
      @redis.zadd(:temperatures, unix_timestamp, "#{unix_timestamp}_#{temperature}")
    end
  end
end
