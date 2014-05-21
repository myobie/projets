class DiscussionsController < ApplicationController
  def index
    render_json project.discussions.map(&DiscussionRepresentation)
  end

  def show
    discussion = Discussion.find(params[:id])
    if discussion.project.member?(current_user)
      render_json DiscussionRepresentation.shared(discussion: discussion).to_hash
    else
      render_not_found_error
    end
  end

  private

  def project
    @project ||= current_user.projects.find(params.require(:project_id))
  end
end
