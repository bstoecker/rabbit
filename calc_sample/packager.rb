#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../worker/worker'
require_relative '../worker/work_tasker'
require_relative '../topics/topic_tasker'

worker = Worker.new('producer-to-packager')
worker.receive_mode do |msg|
  puts " Packager received message: #{msg}"
  values = msg.split('||')
  id = values[0]
  job_count = values[1].to_i

  WorkTasker.new('packager-to-receiver', "#{id}||#{job_count}").send
  sleep(0.5)
  job_count.times do |job|
    new_msg  = "#{id}||#{job}"
    WorkTasker.new('packager-to-calculator', "#{id}||#{job + 1}").send
    sleep(0.1)
  end
end
