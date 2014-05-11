require 'securerandom'

module Factories
  class AttachmentFactory < BaseFactory
    def defaults
      {
        original_filename: random_filename,
        size:              1234,
        content_type:      "image/jpeg",
        key:               random_key,
        attachable:        find_or_build_a_project,
        user:              find_or_build_a_user,
        upload:            build_an_upload
      }
    end

    def random_filename(ext = ".jpg")
      SecureRandom.urlsafe_base64 + ext
    end

    def random_key
      SecureRandom.urlsafe_base64
    end

    def find_or_build_a_project
      Project.first || Factories.build(:project)
    end

    def find_or_build_a_user
      User.first || Factories.build(:user)
    end

    def build_an_upload
      Factories.build :upload
    end
  end
end
