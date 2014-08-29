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
      send_command("rgb #{red},#{green},#{blue}")
    end

    def disable
      send_command("disable")
    end

    def enabled?
      result = send_command("enabled?")
      result.include? '1'
    end

    private

    def send_command(command)
      @lights.write("#{command}\n")
      @lights.read
    end
  end

  class FakeLightService < LightService
    def initialize(device)
      @lights = StringIO.new
    end
  end
end
