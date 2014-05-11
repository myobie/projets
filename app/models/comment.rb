class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates  :commentable, presence: true
  validates  :user,        presence: true
  validates  :content,     presence: true
end
