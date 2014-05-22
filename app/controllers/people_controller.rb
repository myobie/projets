class PeopleController < ApplicationController
  def index
    render_json current_user.known_users.map(&UserRepresentation)
  end

  def show
    if Integer(params[:id]) == current_user_id
      json = UserRepresentation.shared(user: current_user).to_hash
      render_json json
    else
      render_not_found_error
    end
  end

  def avatar
    redirect_to "https://s3.amazonaws.com/projets-avatars-development/users/#{params.require(:person_id)}.jpg"
  end
end
