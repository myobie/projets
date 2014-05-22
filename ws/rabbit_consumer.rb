require 'bunny'

class RabbitConsumer
  def self.cached_connection
    @connection ||= Bunny.new.tap { |bunny| bunny.start }
  end

  def self.cached_channel
    @channel ||= cached_connection.create_channel
  end

  def self.cached_exchange
    @exchange ||= cached_channel.topic "events", durable: true, exclusive: false
  end

  def self.shutdown
    @connection.close if @connection
  end

  %w(connection channel exchange).each do |m|
    cached_m = :"cached_#{m}"
    define_method(m.intern) { self.class.send(cached_m) }
  end

  def initialize(socket, routing_key)
    puts "Starting a rabbit consumer for #{routing_key}"
    @queue = channel.queue("events", exclusive: false, durable: true).bind exchange, routing_key: routing_key
    @subscription = @queue.subscribe(ack: true) do |delivery_info, metadata, payload|
      socket.send payload
      channel.acknowledge delivery_info.delivery_tag, false
    end
  end

  def cancel
    puts "Cancelling rabbit subscription"
    @subscription.cancel
  end
end
