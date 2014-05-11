require 'spec_helper'

describe Account do
  describe "has an owner" do
    let(:account) { create :account }
    let(:account_without_an_owner) { build :account, owner: nil }

    it { expect(account.owner).to_not be_nil }
    it { expect(account_without_an_owner).to_not be_valid }
  end

  describe "can add admins" do
    let(:account) { create :account }
    let(:user) { create :user }

    it do
      expect {
        account.add_admin(user)
      }.to change { account.reload.admins.count }
    end
  end

  describe "can remove admins" do
    let(:account) { create :account }
    let(:user) { create :user }
    before { account.add_admin user }

    it do
      expect {
        account.remove_admin(user)
      }.to change { account.reload.admins.count}.by(-1)
    end
  end

  describe "should know everyone availabe from an account" do
    let(:account) { create :account }
    let(:users) do
      5.times.map { create :user }
    end
    let(:other_user) { create :user }
    let(:everyone) { users + [other_user] }
    before do
      users.each do |user|
        project = create :project, account: account
        project.add_member user
        project.add_member other_user
      end
    end
    it { expect(account.everyone).to eq(everyone) }
  end
end
