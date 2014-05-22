require_relative 'rabbit_connection'
require_relative 'change_processor'

class Worker
  def initialize
    @channel = RabbitConnection.create_channel
    @queue = @channel.queue "changes", durable: true, exclusive: false
  end

  def start
    puts "Subscribing to the changes queue\n"
    @subscription = @queue.subscribe(ack: true) do |delivery_info, metadata, payload|
      ChangeProcessor.call(payload)
      @channel.acknowledge delivery_info.delivery_tag, false
    end
  end

  def cancel
    @subscription.cancel if @subscription
  end
end

