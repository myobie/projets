require 'spec_helper'

describe "Homepage" do

  it "requires access_token" do
    get "/", {}, "HTTP_ACCEPT" => "text/html"
    expect(response.code).to eq("401")
  end

  context "with an access_token" do
    let(:user) { create :user }
    let(:access_token) { AccessToken.generate(user) }

    it "permits the request for the homepage" do
      get "/", {}, "X-Access-Token" => access_token.token_header, "HTTP_ACCEPT" => "text/html"
      expect(response).to be_success
    end
  end

end
