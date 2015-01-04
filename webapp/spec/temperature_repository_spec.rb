module Bolt
  describe TemperatureRepository do
    before(:each) do
      @influxdb_client = instance_double('InfluxDBClient')
      @repository = TemperatureRepository.new(@influxdb_client)
    end

    it 'stores a temperature in database' do
      temperature = 22.4
      expect(@influxdb_client).to receive(:write_point).with("temperatures", {:value => temperature})

      @repository.put(temperature)
    end

    it 'finds temperatures for today' do
      expect(@influxdb_client).to receive(:query).with("select * from temperatures where time > #{Date.today}").and_return(stubbed_temperatures)

      result = @repository.find_today_temperatures

      expect(result[0]).to eq({:temperature => 21.67, :timestamp => 1413307633})
    end

    it 'finds mean temperature for today' do
      value = 21.03
      expect(@influxdb_client).to receive(:query).with("select mean(value) from temperatures where time > #{Date.today}").and_return([{"mean" => value}])

      result = @repository.find_today_mean_temperature

      expect(result).to eq(value)
    end

    it 'finds minimum temperature for today' do
      value = 21.03
      expect(@influxdb_client).to receive(:query).with("select min(value) from temperatures where time > #{Date.today}").and_return([{"min" => value}])

      result = @repository.find_today_minimum_temperature

      expect(result).to eq(value)
    end
    it 'finds maximum temperature for today' do
      value = 21.03
      expect(@influxdb_client).to receive(:query).with("select max(value) from temperatures where time > #{Date.today}").and_return([{"max" => value}])

      result = @repository.find_today_maximum_temperature

      expect(result).to eq(value)
    end

    def stubbed_temperatures
      [{"time" => 1413307633, "value" => 21.67}, {"time" => 1413307693, "value" => 21.56}, {"time" => 1413307753, "value" => 21.56}]
    end
  end
end
