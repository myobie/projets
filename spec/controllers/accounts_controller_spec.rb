require 'spec_helper'

describe AccountsController do
  before { stub_current_user }

  describe "index" do
    context "(with some projects in differnet accounts)" do
      before do
        @projects = 3.times.map do
          create :project, owner: current_user,
                           member_ids: [current_user.id],
                           account: build(:account)
        end
        @accounts = @projects.map(&:account)
      end

      describe "should return a list of accounts" do
        before { get :index }
        it { expect(response).to be_success }
        it { expect(json_response.length).to eq(3) }
      end
    end
  end
end
