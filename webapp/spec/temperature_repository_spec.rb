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
  end
end
