class DiscussionsController < ApplicationController
  def index
    render_json project.discussions.map(&DiscussionRepresentation)
  end

  private

  def project
    @project ||= current_user.projects.find(params.require(:project_id))
  end
end
