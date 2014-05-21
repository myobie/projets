require 'eventmachine'

module SocketPingPong
  module_function

  def call(socket)
    if socket.pingable?
      ping_interval = ENV.fetch("WEBSOCKETS_PING_INTERVAL", 20)
      timer = EM.add_periodic_timer(ping_interval) do
        puts "Sending Ping"
        socket.ping 'hello'
      end

      socket.onping do |message|
        socket.pong message
      end

      socket.onclose do
        puts "Cancelling the ping pong timer"
        timer.cancel
      end
    end
  end
end
