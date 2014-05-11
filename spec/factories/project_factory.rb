require 'securerandom'

module Factories
  class ProjectFactory < BaseFactory
    def defaults
      {
        name:    random,
        owner:   find_or_build_a_user,
        account: find_or_build_an_account
      }
    end

    def random
      SecureRandom.urlsafe_base64
    end

    def find_or_build_a_user
      User.first || Factories.build(:user)
    end

    def find_or_build_an_account
      Account.first || Factories.build(:account)
    end
  end
end
