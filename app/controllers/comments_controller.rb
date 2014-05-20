class CommentsController < ApplicationController
  def index
    with_commentable do |commentable|
      render_json commentable.comments.map(&CommentRepresentation)
    end
  end

  private

  def with_commentable
    case params[:parent_type]
    when "discussion"
      discussion = Discussion.find(params[:discussion_id])
      if discussion.project.member?(current_user)
        yield discussion
      else
        render_not_found_error
      end
    else
      render_not_found_error
    end
  end
end
