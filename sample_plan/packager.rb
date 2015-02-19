#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'

while(true) do

  conn = Bunny.new
  conn.start

  # Receive package job

  ch  = conn.create_channel
  x   = ch.topic("packager-in")
  q   = ch.queue("", :exclusive => true)

  q.bind(x, :routing_key => 'packager-in')

  puts " [*] Waiting for package requests. To exit press CTRL+C"

  id = nil
  jobs = []

  begin
    q.subscribe(:block => true) do |delivery_info, properties, body|
      puts " [x] #{delivery_info.routing_key}:#{body}"
      values  = body.split('||')
      id      = values[0]
      content = values[1]
      content.to_i.times { |i| jobs << (i + 1) }
      ch.close
    end
  rescue Interrupt => _
    ch.close
    conn.close
  end

  # Send result coordinator id and jobcount

  puts 'sending jobs and confirmation'

  ch       = conn.create_channel
  x        = ch.topic("packager-out")
  msg      = "#{id}||#{jobs.size.to_s}"

  x.publish(msg, :routing_key => "packager-out.id")
  puts " [x] Sent packager-out.id: #{msg}"

  ch.close

  # Create calculation jobs

  puts 'sending jobs to calculator'

  ch       = conn.create_channel
  x        = ch.topic("calculator-in")

  jobs.each do |job|
    msg = "#{id}||#{job}"

    x.publish(msg, :routing_key => 'calculator-in')
    puts " [x] Sent calculator-in:#{msg}"
  end
  ch.close

  conn.close

end
