module Bolt
  describe TemperatureRepository do
    before(:each) do
      @redis_client = instance_double('RedisClient')
      @repository = TemperatureRepository.new(@redis_client)
    end

    it 'stores a temperature in database' do
      timestamp = Time.new()
      unix_timestamp = timestamp.to_i
      temperature = 22.4

      expect(@redis_client).to receive(:zadd).with(:temperatures, unix_timestamp, "#{unix_timestamp}_#{temperature}")


      @repository.store(timestamp, temperature)
    end

    it 'finds temperatures for today' do
      expect(@redis_client).to receive(:zrangebyscore).with(:temperatures, Date.today.to_time.to_i, '+inf').and_return(stubbed_temperatures)

      result = @repository.find_today_temperatures

      expect(result[0]).to eq({:temperature => 21.67, :timestamp => Time.new(2014, 10, 14, 19, 27, 13)})
    end

    def stubbed_temperatures
      ["1413307633_21.67", "1413307693_21.56", "1413307753_21.56"]
    end
  end
end
