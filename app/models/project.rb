require_relative 'concerns/has_array'
require_relative 'user'

class Project < ActiveRecord::Base
  include Concerns::HasArray

  belongs_to :owner,       class_name: "User", inverse_of: :owned_projects
  belongs_to :account

  has_many   :discussions
  has_many   :attachments, as: :attachable
  has_array  :members,     class_name: "User"

  validates  :name,        presence: true
  validates  :owner,       presence: true
  validates  :account,     presence: true
end
