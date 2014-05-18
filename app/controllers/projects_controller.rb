class ProjectsController < ApplicationController
  def index
    render_json projects.map(&ProjectRepresentation)
  end

  private

  def projects
    if params[:account_id]
      current_user.projects.where(account_id: params[:account_id])
    else
      current_user.projects
    end
  end
end
