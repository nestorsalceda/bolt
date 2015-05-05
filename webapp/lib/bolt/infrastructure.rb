require 'json'
require 'logger'
require 'serialport'
require 'influxdb'

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
      message[:timestamp] = Time.now().to_i
      message = JSON::dump(message)

      @subscribers.each { |subscriber| subscriber.send(message) }
      @logger.info "Broadcasted #{message} to #{@subscribers.length} subscribers"
    end
  end

  class InfluxDBClient
    def initialize(database)
      @influxdb = InfluxDB::Client.new(database)
    end

    def write_point(name, data)
      @influxdb.write_point(name, data)
    end

    def query(criteria)
      result = []
      @influxdb.query(criteria) do |name, points|
        result = points
      end
      result
    end

    def delete_series(series)
      @influxdb.delete_series(series)
    end
  end
end
