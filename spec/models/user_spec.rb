require 'spec_helper'

describe User do
  describe "memberships" do
    let(:user) { create :user }
    let(:projects) do
      3.times.map { create :project, user_ids: [user] }
    end
    let(:other_projects) do
      3.times.map { create :project }
    end

    context "with some projects" do
      before do
        user && projects && other_projects
      end

      describe "should return the projects" do
        it { expect(user.projects).to eq(projects) }
      end

      it "should be a member of each project" do
        projects.each do |project|
          expect(user).to be_member(project)
        end
      end

      it "should not be a member of the other projects" do
        other_projects.each do |project|
          expect(user).to_not be_member(project)
        end
      end

      describe "can join one of the other projects" do
        let(:other_project) { other_projects.first }
        let(:current_projects) { projects + [other_project] }
        before { user.join(other_project) }
        it { expect(user.projects).to eq(current_projects) }
      end
    end
  end

  describe "should know all users on joined projects" do
    let(:user) { create :user }
    let(:other_users) do
      3.times.map { create :user }
    end
    before do
      other_users.each do |other_user|
        project = create :project
        project.add_member user
        project.add_member other_user
      end
    end
    it { expect(user.known_users).to eq(other_users) }
  end
end
