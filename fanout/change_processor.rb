require 'active_record'
require 'pg'

thread_count = Integer(ENV.fetch('WORKER_THREADS', 5))
url = "#{ENV.fetch("DATABASE_URL")}?pool=#{thread_count}"

ActiveRecord::Base.establish_connection url

glob = File.expand_path('../app/models/**/*.rb', __dir__)
Dir[glob].each do |file|
  require file
end

require_relative 'rabbit_connection'

class ChangeProcessor
  attr_reader :payload, :json

  def self.call(payload)
    new(payload).call
  end

  def self.cached_channel
    @producer_channel ||= RabbitConnection.create_channel
  end

  def self.cached_events_exchange
    @events_exchange ||= cached_channel.topic "events", durable: true, exclusive: false
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
    self.class.cached_events_exchange.publish payload, routing_key: "users.#{user.id}"
  end

  def each_user(&blk)
    find_users.each(&blk)
  end

  def subject_type
    json && json["data"] && json["data"]["type"]
  end

  def subject_id
    json && json["data"] && json["data"]["id"]
  end

  def find_users
    case subject_type
    when "comment"
      process_comment
    else
      unknown_change_type
    end
  end

  def process_comment
    comment = Comment.find(subject_id)

    puts "Processing change for comment #{comment.id}\n"

    case comment.commentable_type
    when "Discussion"
      comment.commentable.project.members
    else
      puts "Don't understand this type of comment with commentable_type '#{comment.commentable_type}'\n"
      []
    end
  end

  def unknown_change_type
    puts "Don't understand the change for subject type '#{subject_type}' (#{json.inspect})\n"
    []
  end
end
