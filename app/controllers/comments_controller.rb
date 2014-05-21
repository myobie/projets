class CommentsController < ApplicationController
  def index
    with_commentable do |commentable|
      render_json commentable.comments.map(&CommentRepresentation)
    end
  end

  def create
    with_commentable do |commentable|
      comment = commentable.comments.build(create_params)
      if comment.save
        json = CommentRepresentation.shared(comment: comment).to_hash
        render_json json, status: 201
      else
        render_validation_errors comment.errors.messages
      end
    end
  end

  def update
    comment = Comment.find(params[:id])
    if comment.user_id == current_user_id
      if comment.update(update_params)
        json = CommentRepresentation.shared(comment: comment).to_hash
        render_json json
      else
        render_validation_errors comment.errors.messages
      end
    else
      render_not_found_error
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.user_id == current_user_id
      comment.destroy
      render_nothing
    else
      render_not_found_error
    end
  end

  private

  def create_params
    {
      user_id: current_user_id,
      content: params[:content]
    }
  end

  def update_params
    params.permit(:content)
  end

  def with_commentable(commentable = nil, &blk)
    commentable_type = commentable ? commentable.class.model_name : params[:parent_type]

    case commentable_type
    when "Discussion"
      with_discussion(commentable, &blk)
    else
      render_not_found_error
    end
  end

  def with_discussion(discussion = nil, &blk)
    discussion ||= Discussion.find(params[:discussion_id])

    if discussion.project.member?(current_user)
      blk.call discussion
    else
      render_not_found_error
    end
  end
end
