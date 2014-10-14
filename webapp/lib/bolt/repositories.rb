require 'date'

module Bolt
  class TemperatureRepository
    def initialize(redis_client)
      @redis = redis_client
    end

    def store(timestamp, temperature)
      unix_timestamp = timestamp.to_i
      @redis.zadd(:temperatures, unix_timestamp, "#{unix_timestamp}_#{temperature}")
    end

    def find_today_temperatures
      key = Date.today.to_time.to_i
      @redis.zrangebyscore(:temperatures, key, '+inf').map do |element|
        time, temperature = element.split('_')
        {:temperature => temperature.to_f, :timestamp => time.to_i}
      end
    end
  end
end
