module Bolt
  class Factory

    def create_lights_handler
      LightsHandler.new(arduino)
    end

    def create_temperature_retriever
      TemperatureRetriever.new(arduino)
    end

    private

    def arduino
      @arduino unless @arduino.nil?

      device = ENV.fetch('ARDUINO_DEVICE', '/dev/ttyACM0')
      @arduino = Arduino.new(device)
    end
  end
end
