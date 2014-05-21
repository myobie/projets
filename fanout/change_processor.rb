require 'active_record'
require 'pg'

ActiveRecord::Base.establish_connection

require_relative '../config/initializers/database_connection'

Dir['../app/models/*.rb'].each do |file|
  require_relative file
end

require_relative 'rabbit_connection'

class ChangeProcessor
  attr_reader :payload, :json

  def self.call(payload)
    new(payload).call
  end

  def initialize(payload)
    @payload = payload
    @json = JSON.parse(@payload)
  end

  def call
    each_user do |user|
      enqueue(user, payload)
    end
  end

  def enqueue(user, payload)
    RabbitConnection.events_exchange.publish(payload, routing_key: "users.#{user.id}")
  end

  def each_user(&blk)
    find_users.each(&blk)
  end

  def find_users
    subject      = json["subject"]
    subject_type = subject["type"]

    case subject_type
    when "comment"
      process_comment
    else
      unknown_change_type
    end
  end

  def process_comment
    comment = Comment.find(json["subject"]["id"])
    puts "Processing change for comment #{comment.id}"
    comment.discussion.project.members
  end

  def unknown_change_type
    puts "Don't understand the change for subject type '#{subject_type}' (#{json.inspect})"
    []
  end
end
