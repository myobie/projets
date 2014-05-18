require 'spec_helper'

describe "Authorization" do

  it "is required to fetch projects" do
    get "/projects"
    expect(response.code).to eq("401")
  end

  context "with an access_token" do
    let(:user) { create :user }
    let(:access_token) { AccessToken.generate(user) }

    it "permits the request to fetch projects" do
      get "/projects", {}, "X-Access-Token" => access_token.token_header
      expect(response).to be_success
      expect(json_response).to eq([])
    end
  end

end
