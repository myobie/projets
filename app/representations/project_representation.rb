class ProjectRepresentation
  include Rep

  initialize_with :project

  fields [
    :account_id,
    :member_ids,
    :name,
    :owner_id,
    :type
  ] => :default

  delegate all_json_fields => :project

  def type
    "project"
  end
end
