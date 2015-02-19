#!/usr/bin/env ruby
# encoding: utf-8

# call this as follows:
# ruby -rubygems coordinator_producer.rb ":id" ":number_of_jobs"

require "bunny"
require 'byebug'

conn = Bunny.new

while (true) do

  conn.start

  # Receive mode task count

  ch_receive  = conn.create_channel
  x_receive   = ch_receive.topic("packager-out")
  q_receive   = ch_receive.queue("", :exclusive => true)

  q_receive.bind(x_receive, :routing_key => "packager-out.id")
  response_count = 0
  id = nil

  begin
    q_receive.subscribe(:block => true) do |delivery_info, properties, body|
      puts " [x] GOT: #{delivery_info.routing_key}: #{body}"
      values = body.split('||')
      id = values[0]
      response_count = values[1].to_i
      ch_receive.close
    end
  rescue Interrupt => _
    ch_receive.close
    conn.close
    break
  end

  # Waiting for other responses:

  ch_calc  = conn.create_channel
  x_calc   = ch_calc.topic("calculator-out")
  q_calc   = ch_calc.queue("", :exclusive => true)

  routing_key = "calculator-out.#{id}"

  puts "routing_key: #{routing_key}"

  q_calc.bind(x_calc, :routing_key => routing_key)

  result = []

  if response_count > 0
    begin
      q_calc.subscribe(:block => true) do |delivery_info, properties, body|
        puts " [x] GOT: #{delivery_info.routing_key}:#{body}"
        puts " Create #{body} many waiters..."
        result << body
        response_count = response_count - 1
        ch_calc.close if response_count == 0
      end
    rescue Interrupt => _
      ch_calc.close
    end
  end

  puts "Connected result = #{result.join('; ')}"

  conn.close

end
