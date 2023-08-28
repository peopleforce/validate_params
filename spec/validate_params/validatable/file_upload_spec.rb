# frozen_string_literal: true

require "fixtures/controllers/file_upload_controller"

RSpec.describe ValidateParams::Validatable do
  subject { ctrl.run_callbacks }

  let(:resume_1) { build_upload(1) }
  let(:resume_2) { build_upload(2) }
  let(:resume_3) { build_upload(3) }

  describe "before_actions" do
    let(:ctrl) { FileUploadController.new(request_params) }

    context "when file is lower size" do
      let(:request_params) { { file: resume_1 } }

      it "returns error" do
        expect(subject).to match hash_including(
          json: { errors: [{ message: "file cannot be less than minimum", min: 1 }], success: false },
          status: :bad_request
        )
      end
    end

    context "when file is bigger size" do
      let(:request_params) { { file: resume_3 } }

      it "returns error" do
        expect(subject).to match hash_including(
          json: { errors: [{ message: "file cannot be more than maximum", max: 153_600 }], success: false },
          status: :bad_request
        )
      end
    end

    context "when file is valid" do
      let(:request_params) { { file: resume_2 } }

      it { is_expected.to be_nil }
    end
  end

  def build_upload(file_number)
    ActionDispatch::Http::UploadedFile.new(tempfile: File.open("spec/fixtures/files/resume_#{file_number}.pdf"),
                                           original_filename: "resume_#{file_number}.pdf",
                                           content_type: "application/pdf",
                                           headers: "Content-Disposition: form-data; name=\"applicant[resume]\"; filename=\"resume_#{file_number}.pdf\"\r\nContent-Type: application/pdf\r\n")
  end
end
