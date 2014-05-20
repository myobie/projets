require 'spec_helper'

describe "Homepage" do

  it "requires access_token" do
    get "/"
    expect(response.code).to eq("401")
  end

  it "expects things to redirect to /" do
    get "/something"
    expect(response.code).to eq("301")
    expect(response.location).to eq("http://www.example.com/#something")
  end

  context "with an access_token" do
    let(:user) { create :user }
    let(:access_token) { AccessToken.generate(user) }

    it "permits the request for the homepage" do
      get "/", {}, "X-Access-Token" => access_token.token_header
      expect(response).to be_success
    end
  end

end
