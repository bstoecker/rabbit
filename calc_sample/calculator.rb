#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../worker/worker'
require_relative '../topics/topic_tasker'

worker = Worker.new('packager-to-calculator')
worker.receive_mode do |msg|
  puts " Calculator received message: #{msg}"
  values = msg.split('||')
  id = values[0]
  new_msg = "Task #{values[1]} DONE"
  topic = 'calculator-to-receiver'
  routing_key = "#{topic}.#{id}"
  sleep(0.5)
  TopicTasker.new(topic, routing_key, new_msg).send
end
