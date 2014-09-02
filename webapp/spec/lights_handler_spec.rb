module Bolt
  describe LightsHandler do
    before(:each) do
      @arduino = instance_double('Arduino')
      @lights_handler = LightsHandler.new(@arduino)
    end

    it 'changes lights color' do
      expect(@arduino).to receive(:send).with("rgb 100,100,100")

      @lights_handler.rgb(100, 100, 100)
    end

    it 'turns off lights' do
      expect(@arduino).to receive(:send).with("disable")

      @lights_handler.disable
    end

    it 'checks if lights are turned on' do
      expect(@arduino).to receive(:send).with("enabled?").and_return('1')

      result = @lights_handler.enabled?

      expect(result).to be(true)
    end
  end
end
