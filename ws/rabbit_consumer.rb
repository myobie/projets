require 'bunny'

class RabbitConsumer
  def self.cached_connection
    @connection ||= Bunny.new.tap { |bunny| bunny.start }
  end

  def self.cached_channel
    @channel ||= connection.create_channel
  end

  def self.cached_exchange
    @exchange ||= channel.topic "events", durable: true
  end

  %w(connection channel exchange).each do |m|
    cached_m = :"cached_#{m}"
    define_method(m.intern) { self.class.send(cached_m) }
  end

  def initialize(socket, routing_key)
    @queue = channel.queue("remote-events", durable: true).bind exchange, routing_key: routing_key
    @subscription = queue.subscribe(ack: true) do |delivery_info, metadata, payload|
      socket.send payload
      channel.acknowledge delivery_info.delivery_tag, false
    end
  end

  def cancel
    @subscription.cancel
  end
end
