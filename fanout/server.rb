$stdout.sync = true
Thread.abort_on_exception = true

require 'bundler'
Bundler.setup

require 'dotenv'
Dotenv.load
Dotenv.overload ".env.#{ENV.fetch("RACK_ENV")}"

require_relative 'worker'

thread_count = Integer(ENV.fetch('WORKER_THREADS', 5))

puts "Making #{thread_count} threads"

threads = thread_count.times.map do
  Thread.new do
    Worker.new.start
  end
end

sleep
