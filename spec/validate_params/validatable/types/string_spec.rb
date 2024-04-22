# frozen_string_literal: true

RSpec.describe ValidateParams::Types::String do
  let(:raw_value) { "" }
  let(:options) { {} }

  subject { described_class.cast(raw_value, **options) }

  describe ".cast" do
    context "called with a Integer value" do
      let(:raw_value) { 1_234 }

      it "returns a string" do
        expect(subject).to eq("1234")
      end
    end

    context "called without options" do
      let(:raw_value) { "Hello, \xFF \u0000 World!" }
      let(:options) { {} }

      it "returns the raw value" do
        expect(subject).to eq("Hello, \xFF \u0000 World!")
      end
    end

    context "called with a scrub_invalid_utf8 option" do
      let(:options) { { scrub_invalid_utf8: true } }

      context "raw value contains invalid UTF-8 characters" do
        let(:raw_value) { "Hello, \xFFWorld!" }

        it "scrubs invalid UTF-8 characters" do
          expect(subject).to eq("Hello, World!")
        end
      end

      context "raw value contains null unicode character" do
        let(:raw_value) { "Hello, \u0000World!" }

        it "scrubs null unicode character" do
          expect(subject).to eq("Hello, World!")
        end
      end

      context "raw value contains emoji" do
        let(:raw_value) { "👍" }

        it "keeps the emoji" do
          expect(subject).to eq("👍")
        end
      end

      context "raw value contains valid UTF8 non-ASCII characters" do
        let(:raw_value) { "Hello, ワールド!" }

        it "keeps the non-ASCII characters" do
          expect(subject).to eq("Hello, ワールド!")
        end
      end
    end
  end
end
