#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new
conn.start

ch  = conn.create_channel
x   = ch.topic("calculator-in")
q   = ch.queue("", :exclusive => true)

q.bind(x, :routing_key => 'calculator-in')

puts " [*] Waiting for calculation jobs. To exit press CTRL+C"

begin
  q.subscribe(:block => true) do |delivery_info, properties, body|

    puts " [x] #{delivery_info.routing_key}:#{body}"

    values = body.split('||')
    id = values[0]
    job = values[1]

    back_ch       = conn.create_channel
    back_x        = ch.topic("calculator-out")
    msg      = "#{id}||job: #{job}||DONE"

    back_x.publish(msg, :routing_key => "calculator-out.#{id}")
    puts " [x] Sent calculator-out.#{id}: #{msg}"

    back_ch.close
  end
rescue Interrupt => _
  ch.close
  conn.close
end

conn.close
