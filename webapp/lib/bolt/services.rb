require 'serialport'

module Bolt
  class LightService
    def initialize
      device = '/dev/ttyACM0'
      bauds = 115200
      data_bits = 8
      stop_bits = 1
      parity = SerialPort::NONE

      @lights = SerialPort.new(device, bauds, data_bits, stop_bits, parity)
      @enabled = false
    end

    def enable(red=255, green=255, blue=255)
      @lights.write("enable #{red},#{green},#{blue}")
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
end
