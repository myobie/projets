require 'securerandom'

module Factories
  class AccountFactory < BaseFactory
    def defaults
      {
        name:  random,
        owner: find_or_build_a_user
      }
    end

    def random
      SecureRandom.urlsafe_base64
    end

    def find_or_build_a_user
      User.first || Factories.build(:user)
    end
  end
end
