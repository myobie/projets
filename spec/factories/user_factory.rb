require 'securerandom'

module Factories
  class UserFactory < BaseFactory
    def defaults
      {
        email: "#{random}@example.com"
      }
    end

    def random
      SecureRandom.urlsafe_base64
    end
  end
end
