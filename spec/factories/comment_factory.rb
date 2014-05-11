require 'securerandom'

module Factories
  class CommentFactory < BaseFactory
    def defaults
      {
        content:     random,
        user:        find_or_build_a_user,
        commentable: find_or_build_a_discussion
      }
    end

    def random
      SecureRandom.urlsafe_base64(200)
    end

    def find_or_build_a_user
      User.first || Factories.build(:user)
    end

    def find_or_build_a_discussion
      Discussion.first || Factories.build(:discussion)
    end
  end
end
