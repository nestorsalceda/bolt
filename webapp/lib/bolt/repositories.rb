module Bolt
  class TemperatureRepository
    def initialize(influxdb_client)
      @influxdb = influxdb_client
    end

    def put(temperature)
      @influxdb.write_point('temperatures', {:value => temperature})
    end

    def find_today_temperatures
      @influxdb.query("select * from temperatures where time > '#{Date.today}'")  do |name, results|
        results.map do |result|
          {:temperature => result["value"], :timestamp => result["time"]}
        end
      end
    end

    def find_today_mean_temperature
      @influxdb.query("select mean(value) from temperatures where time > '#{Date.today}'")["temperatures"]["mean"]
    end

    def find_today_minimum_temperature
      @influxdb.query("select min(value) from temperatures where time > '#{Date.today}'")["temperatures"]["min"]
    end

    def find_today_maximum_temperature
      @influxdb.query("select max(value) from temperatures where time > '#{Date.today}'")["temperatures"]["max"]
    end
  end
end
