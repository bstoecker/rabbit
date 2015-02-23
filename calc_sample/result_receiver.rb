#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../worker/worker'
require_relative '../topics/topic_receiver'
require_relative 'job_set_receiver'

worker = Worker.new('packager-to-receiver')
worker.receive_mode do |msg|
  puts " Receiver received message: #{msg}"
  values = msg.split('||')
  id = values[0]
  job_count = values[1].to_i

  fork do
    puts "Initialized fork #{Process.pid}"

    job_set_receiver = JobSetReceiver.new(
      id, 'calculator-to-receiver', "calculator-to-receiver.#{id}", job_count
    )
    job_set_receiver.receive_mode
  end
end






# fork do
# 2   5.times do
# 3     sleep 1
# 4     puts "I'm an orphan!"
# 5   end
# 6 end


# result = []
#   if job_count > 0
#     topic_receiver = TopicReceiver.new(
#       'calculator-to-receiver', "calculator-to-receiver.#{id}"
#     )
#     topic_receiver.receive_mode do |msg|
#       job_count = job_count - 1
#       result << msg
#       puts "Jobs for id #{id} left: #{job_count}"
#       topic_receiver.close unless job_count > 0
#     end
#   end

#   puts "#{result.join('  \n')}"
