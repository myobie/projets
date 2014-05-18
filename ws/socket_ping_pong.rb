require 'eventmachine'

module SocketPingPong
  def self.included(socket)
    if socket.pingable?
      ping_interval = ENV.fetch("WEBSOCKETS_PING_INTERVAL", 20)
      timer = EM.add_periodic_timer(ping_interval) do
        puts "Sending Ping"
        socket.ping 'hello'
      end

      socket.onping do |message|
        socket.pong message
      end
    end
  end
end
