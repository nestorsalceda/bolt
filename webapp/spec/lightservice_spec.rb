module Bolt
  describe LightService do
    before(:all) do
      @service = LightService.new('/dev/ttyACM0')
    end

    it 'turns on light' do
      @service.rgb(255, 255, 255)

      expect(@service.enabled?).to eq(true)
    end

    it 'turns off light' do
      @service.disable

      expect(@service.enabled?).to eq(false)
    end

    it 'checks temperature' do
      temperature = @service.temperature

      expect(temperature).to be_kind_of(Float)
    end
  end
end
