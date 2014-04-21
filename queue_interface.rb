require 'bunny'

class QueueInterface

  def initialize
    conn = Bunny.new
    conn.start

    @ch = conn.create_channel
    @exchange = @ch.topic('notifications')
  end

  def publish(message, key)
    @exchange.publish(message, :routing_key => key)
  end

  def subscribe(patterns)
    q = @ch.queue('', :exclusive => true)
    patterns.each do |pattern|
      q.bind('notifications', :routing_key => pattern)
    end

    q.subscribe(:block => true) do |delivery_info, properties, body|
      yield(delivery_info, properties, body)
    end
  end
end