require_relative 'worker'

worker = Worker.new('workertest')
worker.receive_mode do |msg|
  puts " [X] Received: #{msg}..."
  sleep msg.count('.').to_i
  puts " [X] ...DONE"
end
