require_relative 'rabbit_connection'
require_relative 'change_processor'

class RabbitConsumer
  def initialize
    @queue = RabbitConnection.changes_queue
    @subscription = queue.subscribe(ack: true) do |delivery_info, metadata, payload|
      ChangeProcessor.call(payload)
      channel.acknowledge delivery_info.delivery_tag, false
    end
  end

  def cancel
    @subscription.cancel
  end
end

