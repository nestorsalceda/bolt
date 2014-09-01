module Bolt
  class MessageHub

    def initialize
      @subscribers = []
    end

    def add_subscriber(subscriber)
      @subscribers << subscriber
    end

    def remove_subscriber(subscriber)
      @subscribers.delete(subscriber)
    end

    def broadcast(message)
      EM.next_tick { @subscribers.each { |subscriber| subscriber.send(message) } }
    end
  end
end
