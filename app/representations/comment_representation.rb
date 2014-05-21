class CommentRepresentation
  include Rep

  initialize_with :comment

  fields [
    :id,
    :content,
    :created_at,
    :created_by_id,
    :parent,
    :type
  ] => :default

  delegate all_json_fields => :comment

  def parent
    {
      id: comment.commentable_id,
      type: comment.commentable_type.underscore
    }
  end

  def created_at
    comment.created_at.iso8601(3)
  end

  def created_by_id
    comment.user_id
  end

  def type
    "comment"
  end
end
