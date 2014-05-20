class DiscussionRepresentation
  include Rep

  initialize_with :discussion

  fields [
    :id,
    :created_by_id,
    :name,
    :project_id,
    :type
  ] => :default

  delegate all_json_fields => :discussion

  def created_by_id
    discussion.user_id
  end

  def type
    "discussion"
  end
end
