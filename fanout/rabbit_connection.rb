require 'bunny'

class RabbitConnection
  def self.cached_connection
    @connection ||= Bunny.new.tap { |bunny| bunny.start }
  end

  def self.create_channel
    cached_connection.create_channel
  end

  def self.shutdown
    @connection.close if @connection
  end
end
