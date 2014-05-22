require 'amqp'

class RabbitConsumer
  def self.cached_connection
    @connection ||= AMQP.connect
  end

  def self.shutdown
    @connection.close if @connection
  end

  def initialize(socket, routing_key)
    puts "Starting a rabbit consumer for #{routing_key}"

    @socket      = socket
    @routing_key = routing_key
    @channel     = AMQP::Channel.new self.class.cached_connection
    @exchange    = @channel.topic "events", durable: true, exclusive: false
    @queue       = @channel.queue("").bind(@exchange, routing_key: @routing_key)
    @consumer    = AMQP::Consumer.new @channel, @queue

    @consumer.consume.on_delivery do |metadata, payload|
      @socket.send payload
      metadata.ack
    end
  end

  def cancel
    puts "Cancelling rabbit subscription"
    @consumer.cancel
  end
end
