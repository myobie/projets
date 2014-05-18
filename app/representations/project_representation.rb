require 'rep'

class ProjectRepresentation
  include Rep

  initialize_with :project

  fields [
    :account_id,
    :name,
    :owner_id,
    :type
  ] => :default

  delegate all_json_fields => :project

  def type
    "project"
  end
end
