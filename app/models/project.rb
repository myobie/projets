class Project < ActiveRecord::Base
  belongs_to :owner, class_name: "User", inverse_of: :owned_projects

  validates :name, presence: true
  validates :owner, presence: true

  def users
    User.where id: user_ids
  end

  def member?(user)
    user_ids.include? user.id
  end

  def add_member(user, raise_on_exception: false)
    add_user_id user.id
    if raise_on_exception
      save!
    else
      save
    end
  end

  def remove_member(user, raise_on_exception: false)
    remove_user_id user.id
    if raise_on_exception
      save!
    else
      save
    end
  end

  private

  def add_user_id(user_id)
    user_ids_will_change!
    self.user_ids << user_id
    clean_up_user_ids
  end

  def remove_user_id(user_id)
    user_ids_will_change!
    self.user_ids.delete user_id
    clean_up_user_ids
  end

  def clean_up_user_ids
    self.user_ids.compact!
    self.user_ids.uniq!
  end
end
