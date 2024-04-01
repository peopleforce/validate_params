# frozen_string_literal: true

require "fixtures/controllers/with_string_controller"

RSpec.describe ValidateParams::Validatable do
  subject { ctrl.run_callbacks }

  let(:title) { "Great Article" }
  let(:description) { "Article Description" }

  let(:ctrl) { WithStringController.new(request_params) }
  let(:request_params) { { title: title, description: description } }

  describe ".perform_validate_params" do
    context "when params are valid" do
      it { is_expected.to be_nil }
    end

    context "when params contains invalid UTF-8 character" do
      context "without params and configuration" do
        let(:title) { "Hello, \xFF \u0000 World!" }

        it { is_expected.to be_nil }

        it "does not change input string" do

        end
      end

      context "with scrub_invalid_utf8 option enabled by default" do
        it "applies to all parameters" do

        end
      end

      context "with scrub_invalid_utf8 option enabled for specific parameter" do
        it "does not change other parameters" do

        end
      end
    end
  end
end
