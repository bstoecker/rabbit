#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'topic_tasker'

routing_key = ARGV.shift || "anonymous.info"
topic = 'topic'
msg      = ARGV.empty? ? "Hello World!" : ARGV.join("||")

puts "Send: topic: #{topic}; routing_key: #{routing_key}, msg: #{msg}"

tt = TopicTasker.new(topic, routing_key, msg).send
