# frozen_string_literal: true

require "fixtures/controllers/nested_controller"
require "fixtures/controllers/nested_override_controller"

describe ValidateParams::Validatable do
  subject { ctrl.run_callbacks }

  let(:date_of_birth) { "2022-01-01" }
  let(:created_at) { "1683749410" }
  let(:quantity) { 5 }
  let(:request_params) do
    {
      date_of_birth: date_of_birth,
      created_at: created_at,
      quantity: quantity
    }
  end

  describe "NestedController" do
    let(:ctrl) { NestedController.new(request_params) }

    context "when created_at is less than minimum" do
      let(:created_at) { "1577881799" }

      it "render json error with localized message" do
        expect(subject).to match hash_including(
          json: hash_including(
            success: false,
            errors: [hash_including(message: "created_at cannot be less than minimum")]
          )
        )
      end
    end

    context "when created_at is more than maximum" do
      let(:created_at) { "1735734601" }

      it "render json error with localized message" do
        expect(subject).to match hash_including(
          json: hash_including(
            success: false,
            errors: [hash_including(message: "created_at cannot be more than maximum")]
          )
        )
      end
    end

    context "when created_at is not valid" do
      let(:created_at) { "NOT VALID DATE" }

      it "render json error with localized message" do
        expect(subject).to match hash_including(
          json: hash_including(
            success: false,
            errors: [hash_including(message: "created_at must be a valid DateTime")]
          )
        )
      end
    end

    context "when date_of_birth is less than minimum" do
      let(:date_of_birth) { "2019-12-31" }

      it "render json error with localized message" do
        expect(subject).to match hash_including(
          json: hash_including(
            success: false,
            errors: [hash_including(message: "date_of_birth cannot be less than minimum")]
          )
        )
      end
    end

    context "when date_of_birth is more than maximum" do
      let(:date_of_birth) { "2026-12-31" }

      it "render json error with localized message" do
        expect(subject).to match hash_including(
          json: hash_including(
            success: false,
            errors: [hash_including(message: "date_of_birth cannot be more than maximum")]
          )
        )
      end
    end

    context "when date_of_birth is invalid" do
      let(:date_of_birth) { "NOT VALID DATE" }

      it "render json error with localized message" do
        expect(subject).to match hash_including(
          json: hash_including(
            success: false,
            errors: [hash_including(message: "date_of_birth must be a valid Date")]
          )
        )
      end
    end

    context "when date_of_birth is less than minimum" do
      let(:quantity) { 0 }

      it "render json error with localized message" do
        expect(subject).to match hash_including(
          json: hash_including(
            success: false,
            errors: [hash_including(message: "quantity cannot be less than minimum")]
          )
        )
      end
    end

    context "when quantity is more than maximum" do
      let(:quantity) { 100 }

      it "render json error with localized message" do
        expect(subject).to match hash_including(
          json: hash_including(
            success: false,
            errors: [hash_including(message: "quantity cannot be more than maximum")]
          )
        )
      end
    end

    context "when quantity is invalid" do
      let(:quantity) { "NOT VALID INTEGER" }

      it "render json error with localized message" do
        expect(subject).to match hash_including(
          json: hash_including(
            success: false,
            errors: [hash_including(message: "quantity must be a valid Integer")]
          )
        )
      end
    end

    context "when all params are valid" do
      it { is_expected.to be_nil }
    end
  end

  describe "NestedOverrideController" do
    let(:ctrl) { NestedOverrideController.new(request_params) }
    let(:request_params) { { date_of_birth: date_of_birth, quantity: quantity } }
    let(:date_of_birth) { Date.new(2024, 2, 1) }
    let(:quantity) { 2 }

    context "when date_of_birth is less than minimum" do
      let(:date_of_birth) { Date.new(2023, 1, 1) }

      it "render json error with localized message" do
        expect(subject).to match hash_including(
          json: hash_including(
            success: false,
            errors: [hash_including(message: "date_of_birth cannot be less than minimum")]
          )
        )
      end
    end

    context "when quantity is invalid" do
      let(:quantity) { "NOT VALID INTEGER" }

      it "render json error with localized message" do
        expect(subject).to match hash_including(
          json: hash_including(
            success: false,
            errors: [hash_including(message: "quantity must be a valid Integer")]
          )
        )
      end
    end
  end
end
