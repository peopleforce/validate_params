# frozen_string_literal: true

RSpec.describe ValidateParams::Types::Boolean do
  let(:raw_value) { nil }
  let(:options) { {} }

  describe ".cast" do
    subject { described_class.cast(raw_value, **options) }

    context "with true values" do
      [true, 1, "1", :"1", "t", :t, "T", :T, "true", :true, "TRUE", :TRUE, "on", :on, "ON", :ON].each do |value|
        context "when raw_value is #{value.inspect}" do
          let(:raw_value) { value }

          it "returns true" do
            expect(subject).to be true
          end
        end
      end
    end

    context "with false values" do
      [false, 0, "0", :"0", "f", :f, "F", :F, "false", :false, "FALSE", :FALSE, "off", :off, "OFF", :OFF].each do |value|
        context "when raw_value is #{value.inspect}" do
          let(:raw_value) { value }

          it "returns false" do
            expect(subject).to be false
          end
        end
      end
    end

    context "with invalid values" do
      ["yes", "no", nil, "", "invalid", 2, -1].each do |value|
        context "when raw_value is #{value.inspect}" do
          let(:raw_value) { value }

          it "returns the raw value" do
            expect(subject).to eq(value)
          end
        end
      end
    end
  end

  describe ".valid?" do
    subject { described_class.valid?(raw_value) }

    context "with true values" do
      [true, 1, "1", :"1", "t", :t, "T", :T, "true", :true, "TRUE", :TRUE, "on", :on, "ON", :ON].each do |value|
        context "when raw_value is #{value.inspect}" do
          let(:raw_value) { value }

          it "returns true" do
            expect(subject).to be true
          end
        end
      end
    end

    context "with false values" do
      [false, 0, "0", :"0", "f", :f, "F", :F, "false", :false, "FALSE", :FALSE, "off", :off, "OFF", :OFF].each do |value|
        context "when raw_value is #{value.inspect}" do
          let(:raw_value) { value }

          it "returns true" do
            expect(subject).to be true
          end
        end
      end
    end

    context "with invalid values" do
      ["yes", "no", nil, "", "invalid", 2, -1].each do |value|
        context "when raw_value is #{value.inspect}" do
          let(:raw_value) { value }

          it "returns false" do
            expect(subject).to be false
          end
        end
      end
    end
  end
end
