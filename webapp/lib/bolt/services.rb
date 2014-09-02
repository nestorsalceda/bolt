require 'rufus-scheduler'

module Bolt
  class LightsHandler
    def initialize(arduino)
      @arduino = arduino
    end

    def rgb(red, green, blue)
      @arduino.send("rgb #{red},#{green},#{blue}")
    end

    def disable
      @arduino.send("disable")
    end

    def enabled?
      @arduino.send("enabled?").include? '1'
    end
  end

  class TemperatureRetriever
    def initialize(arduino)
      @arduino = arduino
    end

    def temperature
      #FIXME: Is not a predicate!
      @arduino.send("temperature?").to_f
    end
  end

  class ScheduledTemperatureRetriever
    def initialize(temperature_retriever, message_hub)
      @temperature_retriever = temperature_retriever
      @message_hub = message_hub
      @scheduler = Rufus::Scheduler.new
    end

    def schedule_and_notify
      @scheduler.every '5m' do
        temperature = @temperature_retriever.temperature
        @message_hub.broadcast({ :type => :temperature_event, :value => temperature })
      end
    end
  end
end
