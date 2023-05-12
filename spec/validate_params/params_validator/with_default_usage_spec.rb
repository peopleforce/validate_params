require "spec_helper"
require "active_support"
require "action_controller"
require_relative "../../../lib/validate_params/params_validator"

DEFAULT_INTEGER = 1234
DEFAULT_DATE = "2022-01-01"
DEFAULT_DATETIME = "1683749410"

RSpec.describe ValidateParams::ParamsValidator, type: :controller do
  subject do
    ctrl.send(:set_params_defaults)
    ctrl.send(:perform_validate_params)
  end
  let(:quantity) { "1234" }
  let(:date_of_birth) { "2022-01-01" }
  let(:created_at) { "1683749410" }

  context "with symbol param name" do
    let(:ctrl) { TestClassDefaultWithSymbol.new }

    before do
      allow(ctrl).to receive(:action_name).and_return("index")
      allow(ctrl).to receive(:params).and_return(request_params)
    end

    describe "before_actions" do
      context "when quantity is not present" do
        let(:request_params) { { date_of_birth: date_of_birth, created_at: created_at } }

        it "returns success" do
          expect(ctrl).not_to receive(:render)
          expect(I18n).not_to receive(:t)
          expect(ctrl).to receive_message_chain(:params, :[]=).with(:quantity, DEFAULT_INTEGER)
          expect(subject).to be_nil
        end
      end

      context "when date_of_birth is not present" do
        let(:request_params) { { quantity: quantity, created_at: created_at } }

        it "returns success" do
          expect(ctrl).not_to receive(:render)
          expect(I18n).not_to receive(:t)
          expect(ctrl).to receive_message_chain(:params, :[]=).with(:date_of_birth, DEFAULT_DATE)
          expect(subject).to be_nil
        end
      end

      context "when created_at is not present" do
        let(:request_params) { { quantity: quantity, date_of_birth: date_of_birth } }

        it "returns success" do
          expect(ctrl).not_to receive(:render)
          expect(I18n).not_to receive(:t)
          expect(ctrl).to receive_message_chain(:params, :[]=).with(:created_at, DEFAULT_DATETIME)
          expect(subject).to be_nil
        end
      end
    end
  end

  context "with hash param name" do
    let(:ctrl) { TestClassDefaultWithHash.new }

    before do
      allow(ctrl).to receive(:action_name).and_return("index")
      allow(ctrl).to receive(:params).and_return(request_params)
    end

    describe "before_actions" do
      context "when quantity is not present" do
        let(:request_params) do
          {
            date_of_birth: { gt: date_of_birth },
            created_at: { lt: created_at }
          }
        end

        it "returns success" do
          expect(ctrl).not_to receive(:render)
          expect(I18n).not_to receive(:t)
          expect(ctrl).to receive_message_chain(:params, :merge!).with({ quantity: { eq: DEFAULT_INTEGER } })
          expect(subject).to be_nil
        end
      end

      context "when date_of_birth is not present" do
        let(:request_params) do
          {
            quantity: { eq: quantity },
            created_at: { lt: created_at }
          }
        end

        it "returns success" do
          expect(ctrl).not_to receive(:render)
          expect(I18n).not_to receive(:t)
          expect(ctrl).to receive_message_chain(:params, :merge!).with({ date_of_birth: { gt: DEFAULT_DATE } })
          expect(subject).to be_nil
        end
      end

      context "when created_at is not present" do
        let(:request_params) do
          {
            quantity: { eq: quantity },
            date_of_birth: { gt: date_of_birth }
          }
        end

        it "returns success" do
          expect(ctrl).not_to receive(:render)
          expect(I18n).not_to receive(:t)
          expect(ctrl).to receive_message_chain(:params, :merge!).with({ created_at: { lt: DEFAULT_DATETIME } })
          expect(subject).to be_nil
        end
      end
    end
  end
end

class TestClassDefaultWithSymbol < ActionController::Base
  include ValidateParams::ParamsValidator

  validate_params_for :index do |p|
    p.param :quantity, Integer, default: DEFAULT_INTEGER
    p.param :date_of_birth, Date, default: DEFAULT_DATE
    p.param :created_at, DateTime, default: DEFAULT_DATETIME
  end

  def index
    "success"
  end
end

class TestClassDefaultWithHash < ActionController::Base
  include ValidateParams::ParamsValidator

  validate_params_for :index do |p|
    p.param :quantity, Hash do |pp|
      pp.param :eq, Integer, default: DEFAULT_INTEGER
    end
    p.param :date_of_birth, Hash do |pp|
      pp.param :gt, Date, default: DEFAULT_DATE
    end
    p.param :created_at, Hash do |pp|
      pp.param :lt, DateTime, default: DEFAULT_DATETIME
    end
  end

  def index
    "success"
  end
end
