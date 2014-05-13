require 'spec_helper'

describe Discussion do
  describe "has a user" do
    let(:discussion) { create :discussion }
    let(:discussion_without_a_user) { build :discussion, user: nil }

    it { expect(discussion.user).to_not be_nil }
    it { expect(discussion_without_a_user).to_not be_valid }
  end

  describe "has a project" do
    let(:discussion) { create :discussion }
    let(:discussion_without_a_project) { build :discussion, project: nil }

    it { expect(discussion.project).to_not be_nil }
    it { expect(discussion_without_a_project).to_not be_valid }
  end

  describe "has a name" do
    let(:discussion) { create :discussion }
    let(:discussion_without_a_name) { build :discussion, name: nil }

    it { expect(discussion.name).to_not be_nil }
    it { expect(discussion_without_a_name).to_not be_valid }
  end
end
