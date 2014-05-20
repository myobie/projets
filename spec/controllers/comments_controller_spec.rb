require 'spec_helper'

describe CommentsController do
  before { stub_current_user }

  describe "index" do
    def create_three_comments(commentable:)
      @comments = 3.times.map do
        create :comment, commentable: @discussion
      end
    end

    context "(with a discussion and some comments)" do
      before do
        @project = create_current_user_project
        @discussion = create :discussion, project: @project
        create_three_comments commentable: @discussion
      end

      describe "returns a list of comments for the discussion" do
        before { get :index, discussion_id: @discussion.id, parent_type: "discussion" }
        it { expect(response).to be_success }
        it { expect(json_response.length).to eq(3) }

        describe "and are the type comment" do
          it { expect(json_response.first["type"]).to eq("comment") }
        end
      end
    end
  end
end
