class UserRepresentation
  include Rep

  initialize_with :user

  fields [
    :id,
    :email,
    :name,
    :type
  ] => :default

  delegate all_json_fields => :user

  def type
    "user"
  end
end
