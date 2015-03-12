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

  class ScheduledTemperatureNotifier
    def initialize(temperature_retriever, message_hub)
      @temperature_retriever = temperature_retriever
      @message_hub = message_hub
      @scheduler = Rufus::Scheduler.new
    end

    def start
      @scheduler.every '1m' do
        temperature = @temperature_retriever.temperature
        @message_hub.broadcast({ :type => :temperature, :value => temperature })
      end
    end
  end

  class ScheduledTemperatureRegisterer
    def initialize(temperature_retriever, temperature_repository)
      @temperature_retriever = temperature_retriever
      @repository = temperature_repository
      @scheduler = Rufus::Scheduler.new
    end

    def start
      @scheduler.every '15m', :first_in => :now do
        temperature = @temperature_retriever.temperature
        @repository.put(temperature)
      end
    end
  end

  class ScheduledTemperaturesForTodayNotifier
    def initialize(temperature_repository, message_hub)
      @repository = temperature_repository
      @message_hub = message_hub
      @scheduler = Rufus::Scheduler.new
    end

    def start
      @scheduler.every '15m', :first_in => '10s' do
        temperatures = @repository.find_today_temperatures
        mean_temperature = @repository.find_today_mean_temperature
        max_temperature = @repository.find_today_maximum_temperature
        min_temperature = @repository.find_today_minimum_temperature
        @message_hub.broadcast({ :type => :today_temperatures, :value => temperatures, :mean => mean_temperature, :maximum => max_temperature, :minimum => min_temperature })
      end
    end
  end
end

