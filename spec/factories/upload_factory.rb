require 'securerandom'

module Factories
  class UploadFactory < BaseFactory
    def defaults
      {
        key:               random,
        user:              find_or_build_a_user,
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
