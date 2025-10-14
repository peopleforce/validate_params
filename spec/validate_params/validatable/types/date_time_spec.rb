# frozen_string_literal: true

RSpec.describe ValidateParams::Types::DateTime do
  let(:raw_value) { "" }
  let(:options) { {} }

  describe ".cast" do
    subject { described_class.cast(raw_value, **options) }

    context "called with a Time value" do
      let(:raw_value) { Time.new(2023, 1, 1, 12, 0, 0, "+00:00") }

      it "returns the same Time object" do
        expect(subject).to eq(raw_value)
      end
    end

    context "called with a valid integer timestamp" do
      let(:raw_value) { 1_678_147_200 }

      it "returns the corresponding Time object" do
        expect(subject).to eq(Time.at(1_678_147_200))
      end
    end

    context "called with an invalid integer timestamp" do
      let(:raw_value) { "invalid_timestamp" }

      it "returns the raw value" do
        expect(subject).to eq("invalid_timestamp")
      end
    end
  end

  describe ".valid?" do
    subject { described_class.valid?(raw_value) }

    context "called with a valid integer timestamp" do
      let(:raw_value) { 1_678_147_200 }

      it "returns true" do
        expect(subject).to be true
      end
    end

    context "called with an invalid integer timestamp" do
      let(:raw_value) { "invalid_timestamp" }

      it "returns false" do
        expect(subject).to be false
      end
    end

    context "called with a timestamp resulting in year > 9999" do
      let(:raw_value) { 253_402_300_800 }

      it "returns false" do
        expect(subject).to be false
      end
    end
  end
end
