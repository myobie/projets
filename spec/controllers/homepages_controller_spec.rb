require 'spec_helper'

describe HomepagesController do
  before { stub_current_user }

  describe "show" do
    describe "should render" do
      subject { get :show }
      it { expect(response).to be_success }
      it { expect(subject).to render_template(:show) }
    end
  end
end
