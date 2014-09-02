module Bolt
  describe TemperatureRetriever do
    before(:each) do
      @arduino = instance_double('Arduino')
      @temperature_retriever = TemperatureRetriever.new(@arduino)
    end

    it 'retrieves temperature' do
      expect(@arduino).to receive(:send).with("temperature?").and_return('25.0')

      result = @temperature_retriever.temperature

      expect(result).to eq(25.0)
    end
  end
end
