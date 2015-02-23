require 'bunny'

class Worker
  def initialize(queue_name)
    @conn = Bunny.new
    @conn.start

    @channel = @conn.create_channel
    @queue = @channel.queue(queue_name, :durable => true)

    @channel.prefetch(1)
  end

  def receive_mode(&handler)
    puts " [*] Waiting for messages in #{@queue.name}. To exit press CTRL+C"
    begin
      @queue.subscribe(manual_ack: true, block: true) do |info, properties, body|
        handler.call(body)

        @channel.ack(info.delivery_tag)
      end
    rescue Interrupt => _
      @conn.close
    end
  end
end
