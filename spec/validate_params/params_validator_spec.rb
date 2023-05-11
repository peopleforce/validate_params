require "spec_helper"
require "active_support"
require "action_controller"
require_relative "../../lib/validate_params/params_validator"

RSpec.describe ValidateParams::ParamsValidator, type: :controller do
  subject do
    ctrl.send(:set_params_defaults)
    ctrl.send(:perform_validate_params)
  end
  let(:id_param) { "1234" }
  let(:date_param) { "2022-01-01" }
  let(:datetime_param) { "1683749410" }

  context "with symbol param name" do
    let(:ctrl) { TestClassWithSymbol.new }
    let(:request_params) { { id_param: id_param, date_param: date_param, datetime_param: datetime_param } }

    before do
      allow(ctrl).to receive(:action_name).and_return("index")
      allow(ctrl).to receive_message_chain(:request, :params).and_return(request_params)
    end

    describe ".perform_validate_params" do
      context "when params are valid" do
        it "returns success" do
          expect(ctrl).not_to receive(:render)
          expect(I18n).not_to receive(:t)
          expect(subject).to be_nil
        end
      end

      context "when integer param invalid" do
        let(:id_param) { "invalid" }

        it "render json error with localized message" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("api.public.invalid_parameter", { field: :id_param, field_type: Integer, field_value: id_param })
          subject
        end
      end

      context "when date param invalid" do
        let(:date_param) { "invalid" }

        it "render json error with localized message" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("api.public.invalid_parameter", { field: :date_param, field_type: Date, field_value: date_param })
          subject
        end
      end

      context "when date param invalid" do
        let(:datetime_param) { "invalid" }

        it "render json error with localized message" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("api.public.invalid_parameter", { field: :datetime_param, field_type: DateTime, field_value: datetime_param })
          subject
        end
      end
    end
  end

  context "with hash param name" do
    let(:ctrl) { TestClassWithHash.new }
    let(:request_params) do
      {
        id_param: { eq: id_param },
        date_param: { gt: date_param },
        datetime_param: { lt: datetime_param }
      }
    end

    before do
      allow(ctrl).to receive(:action_name).and_return("index")
      allow(ctrl).to receive_message_chain(:request, :params).and_return(request_params)
    end

    describe ".perform_validate_params" do
      context "when params are valid" do
        it "returns success" do
          expect(ctrl).not_to receive(:render)
          expect(I18n).not_to receive(:t)
          expect(subject).to be_nil
        end
      end

      context "when integer param invalid" do
        let(:id_param) { "invalid" }

        it "render json error with localized message" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("api.public.invalid_parameter", { field: "id_param[eq]", field_type: Integer, field_value: id_param })
          subject
        end
      end

      context "when date param invalid" do
        let(:date_param) { "invalid" }

        it "render json error with localized message" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("api.public.invalid_parameter", { field: "date_param[gt]", field_type: Date, field_value: date_param })
          subject
        end
      end

      context "when date param invalid" do
        let(:datetime_param) { "invalid" }

        it "render json error with localized message" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("api.public.invalid_parameter", { field: "datetime_param[lt]", field_type: DateTime, field_value: datetime_param })
          subject
        end
      end
    end
  end
end

class TestClassWithSymbol < ActionController::Base
  include ValidateParams::ParamsValidator

  validate_params :index do |p|
    p.param :id_param, Integer
    p.param :date_param, Date
    p.param :datetime_param, DateTime
  end

  def index
    "success"
  end
end

class TestClassWithHash < ActionController::Base
  include ValidateParams::ParamsValidator

  validate_params :index do |p|
    p.param({ id_param: :eq }, Integer)
    p.param({ date_param: :gt }, Date)
    p.param({ datetime_param: :lt }, DateTime)
  end

  def index
    "success"
  end
end
