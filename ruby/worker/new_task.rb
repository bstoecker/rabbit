#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new
conn.start

channel = conn.create_channel
queue    = channel.queue("workertest", :durable => true)

4.times do |i|
  t = rand(1..15)
  msg  = "                      #{i + 1}-th message: " + t.times.map{|j| "."}.join

  queue.publish(msg, :persistent => true)
  puts " [x] Sent #{msg}"
end

sleep 1.0
conn.close
