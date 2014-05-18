require 'securerandom'
require 'bcrypt'
require 'base64'

class AccessToken < ActiveRecord::Base
  belongs_to    :user

  validates     :digest, presence: true
  validates     :expiry, presence: true

  attr_accessor :token

  def self.generate(user, expiry: nil)
    access_token = user.access_tokens.build({
      token:  SecureRandom.urlsafe_base64,
      expiry: expiry || the_distint_future
    })
    if access_token.save
      access_token
    end
  end

  def self.find_by_token_header(token_header)
    if token_header
      user_id_encoded, possible_token = token_header.split("|")
      user_id = Base64.strict_decode64(user_id_encoded)
      tokens = AccessToken.where("expiry > ?", Time.current).where(user_id: user_id).to_a
      tokens.detect { |model| model.authorize(possible_token) }
    end
  end

  def self.the_distint_future
    3.months.from_now
  end

  def token=(new_token)
    if new_token.nil?
      self.digest   = nil
    elsif new_token.present?
      @token        = new_token
      self.digest   = BCrypt::Password.create(new_token)
      self.expiry ||= self.class.the_distint_future
      @token
    end
  end

  def token_header
    if token
      user_id_encoded = Base64.strict_encode64(user_id.to_s)
      "#{user_id_encoded}|#{token}"
    end
  end

  def authorize(possible_token)
    if BCrypt::Password.new(digest) == possible_token
      self
    end
  end
end
