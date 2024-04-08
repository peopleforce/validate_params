# frozen_string_literal: true

require "fixtures/controllers/with_string_controller"

RSpec.describe ValidateParams::Validatable do
  INVALID_UTF_8_STRING = "Hello, \xFF\u0000World!"
  VALID_UTF_8_STRING = "Hello, World!"

  let(:with_scrub) { "" }
  let(:without_scrub) { "" }
  let(:default) { "" }

  let(:ctrl) { WithStringController.new(request_params) }
  let(:request_params) { { with_scrub: with_scrub, without_scrub: without_scrub, default: default } }

  subject { ctrl.run_callbacks }

  describe ".perform_validate_params" do
    context "when params are valid" do
      it { is_expected.to be_nil }
    end

    context "when params contains invalid UTF-8 character" do
      context "without scrub_invalid_utf8 option and configuration" do
        let(:without_scrub) { INVALID_UTF_8_STRING }

        it "does not change input string" do
          expect {
            subject
          }.to_not change { request_params[:without_scrub] }
        end
      end

      context "with scrub_invalid_utf8 option enabled for specific parameter" do
        let(:with_scrub) { INVALID_UTF_8_STRING }
        let(:without_scrub) { INVALID_UTF_8_STRING }
        let(:default) { INVALID_UTF_8_STRING }

        it "removed invalid symbols from parameter" do
          expect {
            subject
          }.to change { request_params[:with_scrub] }.to(VALID_UTF_8_STRING)
        end

        it "does not change parameter with default" do
          expect {
            subject
          }.to_not change { request_params[:default] }
        end

        it "does not change parameter with disabled scrub" do
          expect {
            subject
          }.to_not change { request_params[:without_scrub] }
        end
      end

      context "with scrub_invalid_utf8 option enabled by default" do
        let(:with_scrub) { INVALID_UTF_8_STRING }
        let(:without_scrub) { INVALID_UTF_8_STRING }
        let(:default) { INVALID_UTF_8_STRING }

        it "can be overridden by particular parameter" do
          expect {
            subject
          }.to_not change { request_params[:without_scrub] }
        end
      end
    end
  end
end
