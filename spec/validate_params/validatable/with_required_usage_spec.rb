# frozen_string_literal: true

require "fixtures/controllers/required_with_hash_controller"
require "fixtures/controllers/required_with_symbol_controller"

RSpec.describe ValidateParams::Validatable do
  subject { ctrl.run_callbacks }

  let(:quantity) { "1234" }
  let(:date_of_birth) { "2022-01-01" }
  let(:created_at) { "1683749410" }
  let(:states) { ["active"] }

  context "with symbol param name" do
    let(:ctrl) { RequiredWithSymbolController.new(request_params) }

    describe "before_actions" do
      context "when quantity is not present" do
        let(:request_params) { { date_of_birth: date_of_birth, created_at: created_at, states: states } }

        it "returns error" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(message: "quantity is required")
            )
          )
        end
      end

      context "when date_of_birth is not present" do
        let(:request_params) { { quantity: quantity, created_at: created_at, states: states } }

        it "returns error" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(message: "date_of_birth is required")
            )
          )
        end
      end

      context "when created_at is not present" do
        let(:request_params) { { quantity: quantity, date_of_birth: date_of_birth, created_at: created_at } }

        it "returns error" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(message: "states is required")
            )
          )
        end
      end

      context "when user_ids is not present" do
        let(:request_params) { { quantity: quantity, date_of_birth: date_of_birth } }

        it "returns error" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(message: "created_at is required")
            )
          )
        end
      end
    end
  end

  context "with hash param name" do
    let(:ctrl) { RequiredWithHashController.new(request_params) }

    describe "before_actions" do
      context "when quantity is not present" do
        let(:request_params) { { asd: "22", date_of_birth: { gt: date_of_birth }, created_at: { lt: created_at } } }

        it "returns error" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(message: "quantity[eq] is required")
            )
          )
        end
      end

      context "when date_of_birth is not present" do
        let(:request_params) { { quantity: { eq: quantity }, created_at: { lt: created_at } } }

        it "returns error" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(message: "date_of_birth[gt] is required")
            )
          )
        end
      end

      context "when created_at is not present" do
        let(:request_params) { { quantity: { eq: quantity }, date_of_birth: { gt: date_of_birth } } }

        it "returns error" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(message: "created_at[lt] is required")
            )
          )
        end
      end
    end
  end
end
