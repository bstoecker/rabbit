#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'topic_receiver'

if ARGV.empty?
  abort "Usage: #{$0} [binding key]"
end

topic_routing_key = ARGV[0]

tr = TopicReceiver.new('topic', topic_routing_key)
tr.receive_mode do |msg|
  puts " [x] #{topic_routing_key}: #{msg}"
end
