module Bolt
  class Factory
    def create_lights_handler
      LightsHandler.new(arduino)
    end

    def create_temperature_retriever
      TemperatureRetriever.new(arduino)
    end

    def create_message_hub
      message_hub
    end

    def create_temperature_repository
      TemperatureRepository.new(RedisClient.new('redis://localhost:6379'))
    end

    def create_scheduled_temperature_retriever
      ScheduledTemperatureRetriever.new(create_temperature_retriever, create_message_hub, create_temperature_repository)
    end

    private

    def arduino
      @arduino unless @arduino.nil?

      device = ENV.fetch('ARDUINO_DEVICE', '/dev/ttyACM0')
      @arduino = Arduino.new(device)
    end

    def message_hub
      @message_hub unless @message_hub.nil?

      @message_hub = MessageHub.new
    end
  end
end
