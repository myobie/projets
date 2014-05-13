class Discussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  has_many   :comments,    as: :commentable
  has_many   :attachments, as: :attachable

  validates  :name,        presence: true
  validates  :user,        presence: true
  validates  :project,     presence: true
end
