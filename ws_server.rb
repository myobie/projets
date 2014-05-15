$stdout.sync = true

require 'bundler'
Bundler.setup

require 'em-websocket'
require 'em-synchrony'
require 'em-synchrony/amqp'

port = ENV.fetch("WEBSOCKETS_PORT", 4433)
ping_interval = ENV.fetch("WEBSOCKETS_PING_INTERVAL", 20)
debug_value = ENV["RACK_ENV"] != "production"

bunny = Bunny.new.tap { |bunny| bunny.start }
channel = bunny.create_channel
exchange = channel.topic("events", durable: true)

EM.run do
  EM::WebSocket.run(host: '0.0.0.0', port: port, debug: debug_value) do |socket|
    socket.onopen do |handshake|
      if socket.pingable?
        timer = EM.add_periodic_timer(ping_interval) do
          puts "Sending Ping"
          socket.ping 'hello'
        end
      end

      puts "websocket is open"
      path = handshake.path

      Em.synchrony do
        queue = channel.queue("remote-events", durable: true).bind(exchange, routing_key: path)
        consumer = queue.subscribe(ack: true) do |delivery_info, metadata, payload|
          socket.send(payload)
          channel.acknowledge(delivery_info.delivery_tag, false)
        end
      end

      socket.onclose do
        puts "websocket is closed"
        consumer.cancel
      end

      socket.onmessage do |message|
        # eventually make an http request
      end

      socket.onping do |message|
        socket.pong message
      end
    end
  end
end

connection.close
