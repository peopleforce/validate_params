require "spec_helper"
require "active_support"
require "action_controller"
require_relative "../../../lib/validate_params/params_validator"

RSpec.describe ValidateParams::ParamsValidator, type: :controller do
  subject do
    ctrl.send(:set_params_defaults)
    ctrl.send(:perform_validate_params)
  end
  let(:quantity) { "1234" }
  let(:date_of_birth) { "2022-01-01" }
  let(:created_at) { "1683749410" }

  context "with symbol param name" do
    let(:ctrl) { TestClassRequiredWithSymbol.new }

    before do
      allow(ctrl).to receive(:action_name).and_return("index")
      allow(ctrl).to receive(:params).and_return(request_params)
    end

    describe "before_actions" do
      context "when quantity is not present" do
        let(:request_params) { { date_of_birth: date_of_birth, created_at: created_at } }

        it "returns error" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("validate_params.required", { param: :quantity })
          subject
        end
      end

      context "when date_of_birth is not present" do
        let(:request_params) { { quantity: quantity, created_at: created_at } }

        it "returns error" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("validate_params.required", { param: :date_of_birth })
          subject
        end
      end

      context "when created_at is not present" do
        let(:request_params) { { quantity: quantity, date_of_birth: date_of_birth } }

        it "returns error" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("validate_params.required", { param: :created_at })
          subject
        end
      end
    end
  end

  context "with hash param name" do
    let(:ctrl) { TestClassRequiredWithHash.new }

    before do
      allow(ctrl).to receive(:action_name).and_return("index")
      allow(ctrl).to receive(:params).and_return(request_params)
    end

    describe "before_actions" do
      context "when quantity is not present" do
        let(:request_params) { { date_of_birth: { gt: date_of_birth }, created_at: { lt: created_at } } }

        it "returns error" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("validate_params.required", { param: "quantity[eq]" })
          subject
        end
      end

      context "when date_of_birth is not present" do
        let(:request_params) { { quantity: { eq: quantity }, created_at: { lt: created_at } } }

        it "returns error" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("validate_params.required", { param: "date_of_birth[gt]" })
          subject
        end
      end

      context "when created_at is not present" do
        let(:request_params) { { quantity: { eq: quantity }, date_of_birth: { gt: date_of_birth } } }

        it "returns error" do
          expect(ctrl).to receive(:render)
          expect(I18n).to receive(:t).with("validate_params.required", { param: "created_at[lt]" })
          subject
        end
      end
    end
  end
end

class TestClassRequiredWithSymbol < ActionController::Base
  include ValidateParams::ParamsValidator

  validate_params_for :index do |p|
    p.param :quantity, Integer, required: true
    p.param :date_of_birth, Date, required: true
    p.param :created_at, DateTime, required: true
  end

  def index
    "success"
  end
end

class TestClassRequiredWithHash < ActionController::Base
  include ValidateParams::ParamsValidator

  validate_params_for :index do |p|
    p.param :quantity, Hash do |pp|
      pp.param :eq, Integer, required: true
    end
    p.param :date_of_birth, Hash do |pp|
      pp.param :gt, Date, required: true
    end
    p.param :created_at, Hash do |pp|
      pp.param :lt, DateTime, required: true
    end
  end

  def index
    "success"
  end
end
