require 'serialport'

module Bolt
  class LightService
    def initialize
      device = '/dev/ttyACM1'
      bauds = 115200
      data_bits = 8
      stop_bits = 1
      parity = SerialPort::NONE

      @lights = SerialPort.new(device, bauds, data_bits, stop_bits, parity)
      @enabled = true
    end

    def enable
      @lights.write('enable')
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
