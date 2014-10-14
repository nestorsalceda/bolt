module Bolt
  class Factory
    def lights_handler
      LightsHandler.new(arduino)
    end

    def temperature_retriever
      @temperature_retriever unless @temperature_retriever.nil?

      @temperature_retriever = TemperatureRetriever.new(arduino)
    end

    def message_hub
      @message_hub unless @message_hub.nil?

      @message_hub = MessageHub.new
    end

    def temperature_repository
      @temperature_repository unless @temperature_repository.nil?

      @temperature_repository = TemperatureRepository.new(RedisClient.new('redis://localhost:6379'))
    end

    def scheduled_temperature_retriever
      ScheduledTemperatureRetriever.new(temperature_retriever, message_hub)
    end

    def scheduled_temperature_registerer
      ScheduledTemperatureRegisterer.new(temperature_retriever, temperature_repository)
    end

    private

    def arduino
      @arduino unless @arduino.nil?

      device = ENV.fetch('ARDUINO_DEVICE', '/dev/ttyACM0')
      @arduino = Arduino.new(device)
    end
  end
end
