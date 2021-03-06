class User < ActiveRecord::Base
  has_many  :owned_projects, class_name: "Project", foreign_key: :owner_id, inverse_of: :owner
  has_many  :owned_accounts, class_name: "Account", foreign_key: :owner_id, inverse_of: :owner
  has_many  :access_tokens

  validates :email, presence: true, format: /.+@.+\..+/

  def projects
    Project.where("? = ANY (member_ids)", id)
  end

  def accounts
    Account.where(id: projects.pluck(:account_id))
  end

  def member?(project)
    projects.where(id: project.id).exists?
  end

  def join(project)
    project.add_member(self)
  end

  def known_users
    User.where(id: projects.flat_map(&:member_ids) - [id])
  end
end
