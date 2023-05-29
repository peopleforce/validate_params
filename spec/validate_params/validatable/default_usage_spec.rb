require "spec_helper"
require "active_support"
require "action_controller"
require_relative "../../../lib/validate_params/validatable"

RSpec.describe ValidateParams::Validatable, type: :controller do
  subject do
    ctrl.send(:set_params_defaults)
    ctrl.send(:perform_validate_params)
  end
  let(:quantity) { "1234" }
  let(:date_of_birth) { "2022-01-01" }
  let(:created_at) { "1683749410" }

  context "with symbol param name" do
    let(:ctrl) { TestClassWithSymbol.new }
    let(:request_params) { { quantity: quantity, date_of_birth: date_of_birth, created_at: created_at } }

    before do
      allow(ctrl).to receive(:action_name).and_return("index")
      allow(ctrl).to receive(:params).and_return(request_params)
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
        let(:quantity) { "invalid" }

        it "render json error with localized message" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("validate_params.invalid_type", { param: :quantity, type: Integer })
          subject
        end
      end

      context "when date param invalid" do
        let(:date_of_birth) { "invalid" }

        it "render json error with localized message" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("validate_params.invalid_type", { param: :date_of_birth, type: Date })
          subject
        end
      end

      context "when date param invalid" do
        let(:created_at) { "invalid" }

        it "render json error with localized message" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("validate_params.invalid_type", { param: :created_at, type: DateTime })
          subject
        end
      end
    end
  end

  context "with hash param name" do
    let(:ctrl) { TestClassWithHash.new }
    let(:request_params) do
      {
        quantity: { eq: quantity },
        date_of_birth: { gt: date_of_birth },
        created_at: { gt: created_at, lt: created_at }
      }
    end

    before do
      allow(ctrl).to receive(:action_name).and_return("index")
      allow(ctrl).to receive(:params).and_return(request_params)
    end

    describe ".perform_validate_params" do
      context "when params are valid" do
        it "returns success" do
          expect(ctrl).not_to receive(:render)
          expect(I18n).not_to receive(:t)
          expect(subject).to be_nil
        end
      end

      context "when date param configured as hash and string is passed" do
        let(:request_params) do
          {
            quantity: { eq: quantity },
            date_of_birth: { gt: date_of_birth },
            created_at: created_at
          }
        end

        it "returns success" do
          expect(ctrl).not_to receive(:render)
          expect(I18n).not_to receive(:t)
          expect(subject).to be_nil
        end
      end

      context "when integer param invalid" do
        let(:quantity) { "invalid" }

        it "render json error with localized message" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("validate_params.invalid_type", { param: "quantity[eq]", type: Integer })
          subject
        end
      end

      context "when date param invalid" do
        let(:date_of_birth) { "invalid" }

        it "render json error with localized message" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("validate_params.invalid_type", { param: "date_of_birth[gt]", type: Date })
          subject
        end
      end

      context "when date param invalid" do
        let(:created_at) { "invalid" }

        it "render json error with localized message" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("validate_params.invalid_type", { param: "created_at[gt]", type: DateTime })
          expect(I18n).to receive(:t).with("validate_params.invalid_type", { param: "created_at[lt]", type: DateTime })
          subject
        end
      end
    end
  end
end

class TestClassWithSymbol < ActionController::Base
  include ValidateParams::Validatable

  validate_params_for :index, format: :json do |p|
    p.param :quantity, Integer
    p.param :date_of_birth, Date
    p.param :created_at, DateTime
  end

  def index
    "success"
  end
end

class TestClassWithHash < ActionController::Base
  include ValidateParams::Validatable

  validate_params_for :index, format: :json do |p|
    p.param :quantity, Hash do |pp|
      pp.param :eq, Integer
    end
    p.param :date_of_birth, Hash do |pp|
      pp.param :gt, Date
    end
    p.param :created_at, Hash do |pp|
      pp.param :gt, DateTime
      pp.param :lt, DateTime
    end
  end

  def index
    "success"
  end
end
