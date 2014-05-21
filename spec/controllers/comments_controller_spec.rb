require 'spec_helper'

describe CommentsController do
  before { stub_current_user }

  def create_three_comments(commentable:)
    @comments = 3.times.map do
      create :comment, commentable: commentable
    end
  end

  describe "index" do
    context "(with a discussion and some comments)" do
      before do
        @project = create_current_user_project
        @discussion = create :discussion, project: @project
        create_three_comments commentable: @discussion
      end

      describe "returns a list of comments for the discussion" do
        before { get :index, discussion_id: @discussion.id, parent_type: "Discussion" }
        it { expect(response).to be_success }
        it { expect(json_response.length).to eq(3) }

        describe "and are the type comment" do
          it { expect(json_response.first["type"]).to eq("comment") }
        end
      end
    end
  end

  describe "create" do
    context "(with a discussion)" do
      let(:project) { create_current_user_project }
      let(:discussion) { create :discussion, project: project }

      describe "succeeds" do
        before { post :create, content: "New Comment", parent_type: "Discussion", discussion_id: discussion.id }

        it { expect(response.code).to eq("201") }

        it "and returns the correct type" do
          expect(json_response["type"]).to eq("comment")
        end

        it "and returns the correct parent" do
          expect(json_response["parent"]).to eq("id" => discussion.id, "type" => "discussion")
        end
      end
    end
  end

  describe "update" do
    let(:project) { create_current_user_project }
    let(:discussion) { create :discussion, project: project }
    let(:comment) { create :comment, commentable: discussion }

    describe "succeeds" do
      before { patch :update, id: comment.id, content: "Seriously" }
      it { expect(response).to be_success }

      it "and returns the correct type" do
        expect(json_response["type"]).to eq("comment")
      end
    end
  end

  describe "destroy" do
    let(:project) { create_current_user_project }
    let(:discussion) { create :discussion, project: project }
    let(:comment) { create :comment, commentable: discussion }

    describe "succeeds" do
      before { delete :destroy, id: comment.id }
      it { expect(response).to be_success }
    end
  end
end
