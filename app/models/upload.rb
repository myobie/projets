require 'securerandom'

class Upload < ActiveRecord::Base
  belongs_to :user

  before_validation :generate_key, on: :create

  validates :state, inclusion: { in: %w(new finished cancelled failed) }
  validates :key,   presence: true
  validates :user,  presence: true

  %w(finish cancel fail).each do |m|
    sym = m.to_sym
    define_method(sym) do
      unless machine.trigger(sym)
        self.errors.add :state, "could not transition from #{state} using #{sym}"
      end
    end
  end

  %w(finished cancelled failed).each do |m|
    define_method(:"#{m}?") do
      self.state == m
    end
  end

  def generate_url
    if valid?
      uploads_bucket.objects[self.key].url_for(:put, expires: 10).to_s
    end
  end

  private

  def uploads_bucket
    @uploads_bucket ||= storage.buckets[AwsConfig.uploads_bucket]
  end

  def storage
    @storage ||= AWS::S3.new
  end

  def machine
    @machine ||= MicroMachine.new(state).tap do |fsm|
      fsm.when(:finish, "new" => "finished")
      fsm.when(:cancel, "new" => "cancelled")
      fsm.when(:fail,   "new" => "failed")

      fsm.on(:any) { self.state = machine.state }
    end
  end

  def generate_key
    self.key ||= SecureRandom.uuid
  end
end
