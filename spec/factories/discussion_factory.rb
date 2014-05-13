require 'securerandom'

module Factories
  class DiscussionFactory < BaseFactory
    def defaults
      {
        name:    random,
        user:    find_or_build_a_user,
        project: find_or_build_a_project
      }
    end

    def random
      SecureRandom.urlsafe_base64
    end

    def find_or_build_a_project
      Project.first || Factories.build(:project)
    end

    def find_or_build_a_user
      User.first || Factories.build(:user)
    end
  end
end
