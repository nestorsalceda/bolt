require 'serialport'

module Bolt
  class LightService
    def initialize(device)
      bauds = 115200
      data_bits = 8
      stop_bits = 1
      parity = SerialPort::NONE

      @lights = SerialPort.new(device, bauds, data_bits, stop_bits, parity)
      @enabled = false
    end

    def rgb(red, green, blue)
      @lights.write("rgb #{red},#{green},#{blue}")
      @enabled = true
    end

    def disable
      @lights.write('disable')
      @enabled = false
    end

    def enabled?
      @enabled
    end
  end

  class FakeLightService < LightService
    def initialize(device)
      @lights = StringIO.new
    end
  end
end
