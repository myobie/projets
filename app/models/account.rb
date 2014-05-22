require_relative 'concerns/has_array'
require_relative 'user'

class Account < ActiveRecord::Base
  include Concerns::HasArray

  belongs_to :owner,  class_name: "User", inverse_of: :owned_accounts

  has_many   :projects
  has_array  :admins, class_name: "User"

  validates  :name,  presence: true
  validates  :owner, presence: true

  def everyone
    User.where(id: user_ids_across_all_projects)
  end

  def user_ids_across_all_projects
    projects.pluck(:member_ids).flatten.uniq
  end
end
