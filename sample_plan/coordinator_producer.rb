#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"
require 'byebug'

conn = Bunny.new

# Send job around

conn.start

if ARGV.size < 2
  abort "Arguments are empty"
end

ch       = conn.create_channel
x        = ch.topic("packager-in")

id       = ARGV[0]
msg      = ARGV.join("||")

x.publish(msg, :routing_key => 'packager-in')
puts " [x] Sent packager:#{msg}"
puts 'Waiting...'
puts ''

ch.close

conn.close
