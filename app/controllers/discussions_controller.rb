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

  def create
    if project.member?(current_user)
      discussion = project.discussions.build(create_params)
      if discussion.save
        json = DiscussionRepresentation.shared(discussion: discussion).to_hash
        render_json json, status: 201
      else
        render_validation_errors discussion.errors.messages
      end
    else
      render_not_found_error
    end
  end

  def update
    discussion = Discussion.find(params[:id])
    if discussion.project.member?(current_user)
      if discussion.update(update_params)
        render_json DiscussionRepresentation.shared(discussion: discussion).to_hash
      else
        render_validation_errors discussion.errors.messages
      end
    else
      render_not_found_error
    end
  end

  def destroy
    discussion = Discussion.find(params[:id])
    if discussion.project.member?(current_user)
      discussion.destroy
      render_nothing
    else
      render_not_found_error
    end
  end

  private

  def project
    @project ||= current_user.projects.find(params.require(:project_id))
  end

  def create_params
    {
      name:       params.require(:name),
      project_id: params.require(:project_id),
      user_id:    current_user_id
    }
  end

  def update_params
    params.permit(:name)
  end
end
