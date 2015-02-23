require_relative 'work_tasker'
4.times do |i|
  t = rand(1..15)
  msg  = "                   #{i + 1}-th message: " + t.times.map{|j| "."}.join
  WorkTasker.new('workertest', msg).send
end
