require 'spec_helper'

describe PeopleController do
  before { stub_current_user }

  describe "index" do
    context "(with some people)" do
      before do
        @projects = 5.times.map do
          other_user = create(:user)
          create(:project, {
            owner: current_user,
            member_ids: [other_user.id, current_user.id],
            account: build(:account)
          })
        end
        @other_user = create(:user)
        @other_project = create(:project, {
          owner: @other_user,
          member_ids: [@other_user.id]
        })
      end

      describe "should return a list of people" do
        before { get :index }
        it { expect(response).to be_success }
        it { expect(json_response.length).to eq(5) }
      end
    end
  end
end
