require 'bunny'

class RabbitConnection
  def self.cached_connection
    @connection ||= Bunny.new.tap { |bunny| bunny.start }
  end

  def self.cached_channel
    @channel ||= cached_connection.create_channel
  end

  def self.cached_changes_queue
    @changes_queue ||= cached_channel.queue "changes", durable: true, exclusive: false
  end

  def self.shutdown
    @connection.close if @connection
  end
end
