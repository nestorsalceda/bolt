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

  #class PublishTemperatureService
  #  def initialize(light_service, message_hub)
  #    @light_service = light_service
  #    @message_hub = message_hub
  #    @scheduler = Rufus::Scheduler.new
  #  end

  #  def publish_temperature
  #    @scheduler.every '5s' do
  #      temperature = @light_service.temperature
  #      @message_hub.broadcast(temperature.to_s)
  #    end
  #  end
  #end
end
