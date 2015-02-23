require 'bunny'

class TopicTasker
  def initialize(topic, topic_routing_key, msg)
    @topic = topic
    @topic_routing_key = topic_routing_key
    @msg = msg
    @conn = Bunny.new
  end

  def send
    @conn.start

    channel = @conn.create_channel
    channel.queue('', :durable => true)
    t = channel.topic(@topic)
    t.publish(@msg, :routing_key => @topic_routing_key)

    @conn.close
  end
end
