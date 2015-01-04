module Bolt
  class TemperatureRepository
    def initialize(influxdb_client)
      @influxdb = influxdb_client
    end

    def put(temperature)
      @influxdb.write_point('temperatures', {:value => temperature})
    end

    def find_today_temperatures
      @influxdb.query("select * from temperatures where time > #{Date.today}").map do |result|
        {:temperature => result["value"], :timestamp => result["time"]}
      end
    end
  end
end
