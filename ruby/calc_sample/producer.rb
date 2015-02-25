#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

if ARGV.empty?
  abord 'no arguments given. Enter a task count'
end

task_count = ARGV[0].to_i

conn = Bunny.new
conn.start

channel = conn.create_channel
queue    = channel.queue("producer-to-packager", :durable => true)

task_count.times do |i|
  id = i + 1
  jobs = rand(1..42)

  msg  = "#{id}||#{jobs}"

  queue.publish(msg, :persistent => true)
  puts " [x] Sent #{msg}"
end

sleep 2.0
conn.close
