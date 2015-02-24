#!/usr/bin/env ruby
# encoding: utf-8

require 'byebug'
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
