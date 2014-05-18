class PeopleController < ApplicationController
  def index
    render_json current_user.known_users.map(&UserRepresentation)
  end
end
