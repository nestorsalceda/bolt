require 'json'
require 'logger'
require 'serialport'

module Bolt
  class Arduino
    def initialize(device)
      bauds = 115200
      data_bits = 8
      stop_bits = 1
      parity = SerialPort::NONE

      @arduino = SerialPort.new(device, bauds, data_bits, stop_bits, parity)
      @arduino.read_timeout = 100
      @arduino.readlines
    end

    def send(command)
      @arduino.write("#{command}\n")
      @arduino.read
    end
  end

  class MessageHub

    def initialize
      @subscribers = []
      @logger = Logger.new(STDERR)
    end

    def add_subscriber(subscriber)
      @logger.info "Adding subscriber #{subscriber}"
      @subscribers << subscriber
    end

    def remove_subscriber(subscriber)
      @logger.info "Removing subscriber #{subscriber}"
      @subscribers.delete(subscriber)
    end

    def broadcast(message)
      @subscribers.each { |subscriber| subscriber.send(JSON::dump(message)) }
      @logger.info "Broadcasted #{message} to #{@subscribers.length} subscribers"
    end
  end
end
