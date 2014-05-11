require 'spec_helper'

describe Comment do
  describe "has a user" do
    let(:comment) { create :comment }
    let(:comment_without_a_user) { build :comment, user: nil }

    it { expect(comment.user).to_not be_nil }
    it { expect(comment_without_a_user).to_not be_valid }
  end

  describe "has some content" do
    let(:comment) { create :comment }
    let(:comment_without_content) { build :comment, content: nil }

    it { expect(comment.content).to_not be_nil }
    it { expect(comment_without_content).to_not be_valid }
  end

  describe "has an attachable" do
    let(:comment) { create :comment }
    let(:comment_without_an_commentable) { build :comment, commentable: nil }

    it { expect(comment.commentable).to_not be_nil }
    it { expect(comment_without_an_commentable).to_not be_valid }
  end
end
