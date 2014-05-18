require 'spec_helper'

describe AccessToken do
  describe "::generate" do
    describe "returns an access_token" do
      let(:user) { create :user }
      let(:access_token) { AccessToken.generate(user) }

      it { expect(access_token.token).to be_present }
      it { expect(access_token.user).to eq(user) }
    end
  end
end
