class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  belongs_to :user
  belongs_to :upload

  has_many   :comments,   as: :commentable

  validates  :attachable, presence: true
  validates  :user,       presence: true
  validates  :upload,     presence: true
end
