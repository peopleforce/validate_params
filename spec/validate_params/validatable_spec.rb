# frozen_string_literal: true

RSpec.describe ValidateParams::Validatable do
  context "#configuration" do
    before do
      described_class.configure do |config|
        config.scrub_invalid_utf8 = true
        config.scrub_invalid_utf8_replacement = "unsupported"
      end
    end

    it "supported initializer configuration" do
      expect(described_class.configuration.scrub_invalid_utf8).to eq(true)
      expect(described_class.configuration.scrub_invalid_utf8_replacement).to eq("unsupported")
    end

    it "doesn't accept not supported configuration keys" do
      expect {
        described_class.configure do |config|
          config.unsupported_key = true
        end
      }.to raise_error(NoMethodError)
    end
  end
end
