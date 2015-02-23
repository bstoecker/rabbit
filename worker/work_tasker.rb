require 'bunny'

class WorkTasker

  def initialize(queue_name, msg)
    @queue_name = queue_name
    @msg = msg
    @conn = Bunny.new
  end

  def send
    @conn.start
    channel = @conn.create_channel
    queue   = channel.queue(@queue_name, :durable => true)

    queue.publish(@msg, :persistent => true)

    sleep 1.0

    @conn.close
  end
end
