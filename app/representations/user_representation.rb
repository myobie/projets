class UserRepresentation
  include Rep

  initialize_with :user

  fields [
    :email,
    :name,
    :type
  ] => :default

  delegate all_json_fields => :user

  def type
    "user"
  end
end
