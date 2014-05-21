$stdout.sync = true
Thread.abort_on_exception = true

require 'bundler'
Bundler.setup

require_relative 'rabbit_consumer'

thread_count = Integer(ENV.fetch('DB_POOL', 5))

threads = thread_count.times.map do
  Thread.new do
    RabbitConsumer.new
  end
end

sleep
