$stdout.sync = true

require 'bundler'
Bundler.setup

require 'em-websocket'
require 'em-synchrony'
require 'em-synchrony/amqp'

require_relative 'rabbit_consumer'
require_relative 'socket_ping_pong'
require_relative 'socket_authorization'
require_relative 'message_handler'

port = ENV.fetch("WEBSOCKETS_PORT", 4433)
debug_value = ENV["RACK_ENV"] != "production"

EM.run do
  EM::WebSocket.run(host: '0.0.0.0', port: port, debug: debug_value) do |socket|
    socket.onopen do |handshake|
      puts "websocket is open (#{handshake.path})"

      authorization = SocketAuthorizer.new(handshake)
      socket.close unless authorization.authorized?

      include SocketPingPong

      rabbit_consumer = EM.synchrony do
        RabbitConsumer.new(socket, "user.#{authorizer.user_id}")
      end

      socket.onclose do
        puts "websocket is closed"
        EM.synchrony do
          rabbit_consumer.cancel
        end
      end

      socket.onmessage do |message|
        MessageHandler.call(authorization, socket, message) do |response|
          socket.send JSON.generate(response)
        end
      end
    end
  end
end

connection.close
