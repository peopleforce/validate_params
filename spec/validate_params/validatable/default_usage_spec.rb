# frozen_string_literal: true

require "fixtures/controllers/with_hash_controller"
require "fixtures/controllers/with_symbol_controller"

RSpec.describe ValidateParams::Validatable do
  subject { ctrl.run_callbacks }

  let(:quantity) { "1234" }
  let(:date_of_birth) { "2022-01-01" }
  let(:created_at) { "1683749410" }

  context "with symbol param name" do
    let(:ctrl) { WithSymbolController.new(request_params) }
    let(:request_params) { { quantity: quantity, date_of_birth: date_of_birth, created_at: created_at } }

    describe ".perform_validate_params" do
      context "when params are valid" do
        it { is_expected.to be_nil }
      end

      context "when integer param invalid" do
        let(:quantity) { "invalid" }

        it "render json error with localized message" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(message: "quantity must be a valid Integer")
            )
          )
        end
      end

      context "when date param invalid" do
        let(:date_of_birth) { "invalid" }

        it "render json error with localized message" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(message: "date_of_birth must be a valid Date")
            )
          )
        end
      end

      context "when date param invalid" do
        let(:created_at) { "invalid" }

        it "render json error with localized message" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(message: "created_at must be a valid DateTime")
            )
          )
        end
      end
    end
  end

  context "with hash param name" do
    let(:ctrl) { WithHashController.new(request_params) }
    let(:request_params) do
      {
        quantity: { eq: quantity },
        date_of_birth: { gt: date_of_birth },
        created_at: { gt: created_at, lt: created_at }
      }
    end

    describe ".perform_validate_params" do
      context "when params are valid" do
        it { is_expected.to be_nil }
      end

      context "when date param configured as hash and string is passed" do
        let(:request_params) do
          {
            quantity: { eq: quantity },
            date_of_birth: { gt: date_of_birth },
            created_at: created_at
          }
        end

        it { is_expected.to be_nil }
      end

      context "when integer param invalid" do
        let(:quantity) { "invalid" }

        it "render json error with localized message" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(message: "quantity[eq] must be a valid Integer")
            )
          )
        end
      end

      context "when date param invalid" do
        let(:date_of_birth) { "invalid" }

        it "render json error with localized message" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(message: "date_of_birth[gt] must be a valid Date")
            )
          )
        end
      end

      context "when date param invalid" do
        let(:created_at) { "invalid" }

        it "render json error with localized message" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false,
              errors: array_including(
                { message: "created_at[gt] must be a valid DateTime" },
                { message: "created_at[lt] must be a valid DateTime" }
              )
            )
          )
        end
      end
    end
  end
end
