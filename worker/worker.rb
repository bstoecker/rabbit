#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new
conn.start

channel = conn.create_channel
queue = channel.queue("task_queue", :durable => true)

channel.prefetch(1)
puts " [*] Waiting for messages in #{queue.name}. To exit press CTRL+C"

begin
  queue.subscribe(manual_ack: true, block: true) do |info, properties, body|
    puts " [x] Received #{body}"
    sleep body.count('.').to_i
    puts ' [x] Done'

    channel.ack(info.delivery_tag)
  end
rescue Interrupt => _
  conn.close
end
