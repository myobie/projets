require 'spec_helper'

describe DiscussionsController do
  before { stub_current_user }

  describe "index" do
    context "(with a project and some discussions)" do
      before do
        @project = create_current_user_project
        @discussions = 3.times.map do
          create :discussion, project: @project
        end
      end

      describe "returns a list of discussions for the project" do
        before { get :index, project_id: @project.id }
        it { expect(response).to be_success }
        it { expect(json_response.length).to eq(3) }

        describe "and are the type discussion" do
          it { expect(json_response.first["type"]).to eq("discussion") }
        end
      end
    end

    describe "is not found if a project cannot be found" do
      before { get :index, project_id: 99 }
      it { expect(response).to be_not_found }
    end
  end

  describe "show" do
    context "(with a discussion)" do
      before do
        @project = create_current_user_project
        @discussion = create :discussion, project: @project
      end

      describe "returns the discussion json" do
        before { get :show, id: @discussion.id }
        it { expect(response).to be_success }

        it "with the correct id" do
          expect(json_response["id"]).to eq(@discussion.id)
        end

        it "with the correct type of discussion" do
          expect(json_response["type"]).to eq("discussion")
        end
      end

      describe "returns 404 for non-members" do
        before do
          stub_current_user name: "SomeoneElse"
          get :show, id: @discussion.id
        end

        it { expect(response).to be_not_found }
      end
    end
  end

  describe "create" do
    let(:project) { create_current_user_project }
    before { post :create, name: "New Discussion", project_id: project.id }

    describe "succeeds" do
      it { expect(response.code).to eq("201") }

      it "and should send back the new id" do
        expect(json_response["id"]).to eq(Discussion.last.id)
      end

      it "and should be the correct type" do
        expect(json_response["type"]).to eq("discussion")
      end
    end
  end

  describe "update" do
    let(:project) { create_current_user_project }
    let(:discussion) { create :discussion, project: project }

    describe "succeeds" do
      before { patch :update, id: discussion.id, name: "I mean't to name it this" }
      it { expect(response).to be_success }

      it "and should be the correct type" do
        expect(json_response["type"]).to eq("discussion")
      end
    end
  end

  describe "destroy" do
    let(:project) { create_current_user_project }
    let(:discussion) { create :discussion, project: project }

    describe "succeeds" do
      before { delete :destroy, id: discussion.id }
      it { expect(response).to be_success }
    end
  end
end
