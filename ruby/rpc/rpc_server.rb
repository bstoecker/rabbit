require 'bunny'

class RPCServer
  def initialize(connection, queue_name)
    @conn = connection
    @channel = @conn.create_channel
    @queue_name = queue_name
  end

  def receive_mode(&handler)
    @queue = @channel.queue(@queue_name)
    @x_change = @channel.default_exchange

    @queue.subscribe(:block => true) do |delivery_info, properties, body|
      result = handler.call(body)
      @x_change.publish(
        r.result,
        routing_key: properties.reply_to,
        correlation_id: properties.correlation_id
      )
    end
  end

end
