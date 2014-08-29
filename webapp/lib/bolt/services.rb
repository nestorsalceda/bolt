require 'serialport'

module Bolt
  class LightService
    def initialize(device)
      bauds = 115200
      data_bits = 8
      stop_bits = 1
      parity = SerialPort::NONE

      @lights = SerialPort.new(device, bauds, data_bits, stop_bits, parity)
      @lights.read_timeout = 100
      @lights.readlines
    end

    def rgb(red, green, blue)
      @lights.write("rgb #{red},#{green},#{blue}\n")
    end

    def disable
      @lights.write("disable\n")
    end

    def enabled?
      @lights.write("enabled?\n")
      @lights.read.include?('1')
    end
  end

  class FakeLightService < LightService
    def initialize(device)
      @lights = StringIO.new
    end
  end
end
