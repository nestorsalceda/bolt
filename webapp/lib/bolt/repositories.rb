module Bolt
  class TemperatureRepository
    def initialize(influxdb_client)
      @influxdb = influxdb_client
    end

    def put(temperature)
      @influxdb.write_point('temperatures', {:value => temperature})
    end

    def find_today_temperatures
      @influxdb.query("select * from temperatures where time > '#{Date.today}'").map  do |result|
        {:temperature => result["value"], :timestamp => result["time"]}
      end
    end

    def find_today_mean_temperature
      result = @influxdb.query("select mean(value) from temperatures where time > '#{Date.today}'")
      return result[0]["mean"] unless result.length == 0
    end

    def find_today_minimum_temperature
      result = @influxdb.query("select min(value) from temperatures where time > '#{Date.today}'")
      return result[0]["min"] unless result.length == 0
    end

    def find_today_maximum_temperature
      result = @influxdb.query("select max(value) from temperatures where time > '#{Date.today}'")
      return result[0]["max"] unless result.length == 0
    end
  end
end
