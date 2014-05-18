class AccountRepresentation
  include Rep

  initialize_with :account

  fields [
    :id,
    :admin_ids,
    :name,
    :owner_id,
    :type
  ] => :default

  delegate all_json_fields => :account

  def type
    "account"
  end
end
