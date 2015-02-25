require 'bunny'

class TopicReceiver
  def initialize(topic, topic_routing_keys, queue_name = '')
    @conn = Bunny.new
    @conn.start

    @channel = @conn.create_channel
    t = @channel.topic(topic)
    @queue = @channel.queue(queue_name, :exclusive => true)

    @queue.bind(t, :routing_key => topic_routing_keys)
  end

  def receive_mode(&handler)
    puts " [*] Waiting for messages in #{@queue.name}. To exit press CTRL+C"
    begin
      @queue.subscribe(:block => true) do |delivery_info, properties, body|
        handler.call(body)
      end
    rescue Interrupt => _
      close
    end
  end

  def receive_once(&handler)
    puts " [*] Waiting for single message in #{@queue.name}. "\
         "To exit press CTRL+C"
    receive_mode do |msg|
      result = handler.call(msg)
      close
      result
    end
  end

  def close
    @channel.close
    @conn.close
  end
end
