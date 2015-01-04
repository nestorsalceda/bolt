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
      return @message_hub unless @message_hub.nil?

      @message_hub = MessageHub.new
    end

    def temperature_repository
      return @temperature_repository unless @temperature_repository.nil?

      @temperature_repository = TemperatureRepository.new(InfluxDBClient.new('bolt'))
    end

    def scheduled_temperature_notifier
      ScheduledTemperatureNotifier.new(temperature_retriever, message_hub)
    end

    def scheduled_temperature_registerer
      ScheduledTemperatureRegisterer.new(temperature_retriever, temperature_repository)
    end

    def scheduled_temperatures_for_today_notifier
      ScheduledTemperaturesForTodayNotifier.new(temperature_repository, message_hub)
    end

    private

    def arduino
      return @arduino unless @arduino.nil?

      if ENV['DEBUG'].nil?
        device = ENV.fetch('ARDUINO_DEVICE', '/dev/ttyACM0')
        @arduino = Arduino.new(device)
      else
        @arduino = FakeArduino.new
      end
    end

    class FakeArduino
      def send(command)
        return '0'
      end
    end
  end
end
