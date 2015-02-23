puts "This is the first line before the fork (pid #{Process.pid})"
puts fork
puts "This is the second line after the fork (pid #{Process.pid})"
