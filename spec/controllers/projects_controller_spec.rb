require 'spec_helper'

describe ProjectsController do
  before { stub_current_user }

  describe "index" do
    context "(with some projects)" do
      before do
        @projects = 2.times.map do
          create :project, owner: current_user,
                           member_ids: [current_user.id],
                           account: build(:account)
        end
      end

      describe "returns a list of projects" do
        before { get :index }
        it { expect(json_response.length).to eq(2) }

        it "with type as project" do
          expect(json_response.first["type"]).to eq("project")
        end
      end

      context "just for one account" do
        describe "still returns a list of projects" do
          let(:first_project) { @projects.first }
          before { get :index, account_id: first_project.account_id }
          it { expect(json_response.length).to eq(1) }
          it { expect(json_response.first["account_id"]).to eq(first_project.account_id) }
        end
      end
    end
  end
end
