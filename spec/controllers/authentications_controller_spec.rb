require 'spec_helper'

describe AuthenticationsController do
  describe "receiving a token" do
    let(:user)         { create :user }
    let(:access_token) { AccessToken.generate(user) }

    describe "finds the user" do
      before { post :create, token: access_token.token_header }
      it { expect(assigns(:user)).to eq(user) }
      it { expect(response).to be_redirect }
    end

    describe "generates another token" do
      before do
        token = access_token.token_header
        allow(AccessToken).to receive(:generate).and_return(access_token)
        post :create, token: token
      end
      it { expect(AccessToken).to have_received(:generate).with(user) }
    end

    describe "sets a cookie" do
      before { post :create, token: access_token.token_header }

      it { expect(cookies.permanent.signed[:access_token]).to be_present }

      it "and can find the user" do
        cookied_token = AccessToken.find_by_token_header(cookies.permanent.signed[:access_token])
        expect(cookied_token.user).to eq(user)
      end
    end
  end
end
