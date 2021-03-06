require 'spec_helper'

describe Project do
  describe "has a name" do
    let(:project) { create :project }
    let(:project_without_a_name) { build :project, name: nil }

    it { expect(project.name).to_not be_nil }
    it { expect(project_without_a_name).to_not be_valid }
  end

  describe "has an owner" do
    let(:project) { create :project }
    let(:project_without_an_owner) { build :project, owner: nil }

    it { expect(project.owner).to_not be_nil }
    it { expect(project_without_an_owner).to_not be_valid }
  end

  describe "can add members" do
    let(:project) { create :project }
    let(:user) { create :user }

    it do
      expect {
        project.add_member(user)
      }.to change { project.reload.members.count }
    end
  end

  describe "can remove members" do
    let(:project) { create :project }
    let(:user) { create :user }
    before { project.add_member user }

    it do
      expect {
        project.remove_member(user)
      }.to change { project.reload.members.count }.by(-1)
    end
  end
end
