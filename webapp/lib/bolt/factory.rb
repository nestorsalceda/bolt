module Bolt
  class Factory
    def self.create_light_service
      debug = ENV.fetch('DEBUG', false)
      device = ENV.fetch('ARDUINO_DEVICE', '/dev/ttyACM0')
      if debug
        FakeLightService.new(device)
      else
        LightService.new(device)
      end
    end
  end
end
