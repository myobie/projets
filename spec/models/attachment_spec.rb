require 'spec_helper'

describe Attachment do
  describe "has a user" do
    let(:attachment) { create :attachment }
    let(:attachment_without_a_user) { build :attachment, user: nil }

    it { expect(attachment.user).to_not be_nil }
    it { expect(attachment_without_a_user).to_not be_valid }
  end

  describe "has an upload" do
    let(:attachment) { create :attachment }
    let(:attachment_without_an_upload) { build :attachment, upload: nil }

    it { expect(attachment.upload).to_not be_nil }
    it { expect(attachment_without_an_upload).to_not be_valid }
  end

  describe "has an attachable" do
    let(:attachment) { create :attachment }
    let(:attachment_without_an_attachable) { build :attachment, attachable: nil }

    it { expect(attachment.attachable).to_not be_nil }
    it { expect(attachment_without_an_attachable).to_not be_valid }
  end

  describe "the related upload must be finished" do
    let(:upload) { create :upload, state: "cancelled" }
    let(:attachment) { build :attachment, upload: upload }
    before { attachment.valid? }

    it { expect(attachment.errors.messages.keys).to include(:upload) }
  end

  describe "can generate a url" do
    let(:attachment) { create :attachment }
    it { expect(attachment.generate_url).to match(%r{^https://}) }
  end
end
