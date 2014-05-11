require 'spec_helper'

describe Upload do
  describe "has a user" do
    let(:upload) { create :upload }
    let(:upload_without_a_user) { build :upload, user: nil }

    it { expect(upload.user).to_not be_nil }
    it { expect(upload_without_a_user).to_not be_valid }
  end

  describe "finish" do
    describe "updates state" do
      let(:upload) { create :upload }
      before { upload.finish }

      it { expect(upload.state).to eq("finished") }
      it { expect(upload).to be_finished }
    end

    describe "for an invalid transition" do
      let(:upload) { create :upload, state: "cancelled" }
      before { upload.finish }

      it "doesn't change the state" do
        expect { upload.finish }.to_not change { upload.state }
      end

      it "adds an error" do
        upload.finish
        expect(upload.errors.messages.keys).to include(:state)
      end
    end
  end

  describe "generates a form for uploading" do
    let(:upload) { create :upload }
    it { expect { upload.generate_form }.to_not raise_error }
    it { expect(upload.generate_form.url.to_s).to match(%r{^https://}) }
  end
end
