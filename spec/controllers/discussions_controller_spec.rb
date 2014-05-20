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
end
