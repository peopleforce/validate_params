# frozen_string_literal: true

require "fixtures/controllers/default_with_hash_controller"
require "fixtures/controllers/default_with_symbol_controller"

RSpec.describe ValidateParams::Validatable do
  subject { ctrl.run_callbacks }

  let(:quantity) { "1234" }
  let(:date_of_birth) { "2022-01-01" }
  let(:created_at) { "1683749410" }
  let(:weight) { 3.14 }

  context "with symbol param name" do
    let(:ctrl) { DefaultWithSymbolController.new(request_params) }

    describe "before_actions" do
      context "when quantity is not present" do
        let(:request_params) { { date_of_birth: date_of_birth, created_at: created_at } }

        it "returns success" do
          subject

          expect(request_params[:quantity]).to eq(1234)
          expect(request_params[:date_of_birth]).to eq(Date.parse(date_of_birth))
          expect(request_params[:created_at]).to eq(Time.at(created_at.to_i))
          expect(request_params[:user_ids]).to eq([1])
        end
      end

      context "when date_of_birth is not present" do
        let(:request_params) { { quantity: quantity, created_at: created_at } }

        it "returns success" do
          subject

          expect(request_params[:date_of_birth]).to eq(Date.parse(date_of_birth))
        end
      end

      context "when created_at is not present" do
        let(:request_params) { { quantity: quantity, date_of_birth: date_of_birth } }

        it "returns success" do
          subject

          expect(request_params[:created_at]).to eq(Time.at(created_at.to_i))
        end
      end

      context "when user_ids of: Integer passed in as integers" do
        let(:request_params) { { user_ids: [1, 2, 3] } }

        it "returns success" do
          subject
          expect(request_params[:user_ids]).to eq([1, 2, 3])
        end
      end

      context "when user_ids of: Integer passed in as strings" do
        let(:request_params) { { user_ids: %w[1 2 3] } }

        it "returns success" do
          subject
          expect(request_params[:user_ids]).to eq([1, 2, 3])
        end
      end

      context "when weight is present" do
        let(:request_params) { { weight: weight } }

        it "returns success" do
          subject
          expect(request_params[:weight]).to eq(weight)
        end
      end

      context "when weight is numeric string" do
        let(:request_params) { { weight: weight.to_s } }

        it "returns success" do
          subject
          expect(request_params[:weight]).to eq(weight)
        end
      end

      context "when weight is integer" do
        let(:request_params) { { weight: 3 } }

        it "returns failure" do
          subject
          expect(request_params[:weight]).to eq(3)
        end
      end

      context "when weight is nil" do
        let(:request_params) { { weight: nil } }

        it "returns failure" do
          subject
          expect(request_params[:weight]).to eq(nil)
        end
      end

      context "when weight is string" do
        let(:request_params) { { weight: "one" } }

        it "returns failure" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false
            )
          )
        end
      end

      context "when user_ids of: Integer passed in as invalid strings" do
        let(:request_params) { { user_ids: %w[1a 2 3] } }

        it "returns failure" do
          subject
          expect(subject).to match hash_including(
            json: hash_including(
              success: false
            )
          )
        end
      end
    end
  end

  context "with hash param name" do
    let(:ctrl) { DefaultWithHashController.new(request_params) }

    describe "before_actions" do
      context "when quantity is not present" do
        let(:request_params) do
          {
            date_of_birth: { gt: date_of_birth },
            created_at: { lt: created_at }
          }
        end

        it "returns success" do
          subject

          expect(request_params.dig(:quantity, :eq)).to be_a(Integer)
          expect(request_params.dig(:quantity, :eq)).to eq(1234)
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
          subject

          expect(request_params.dig(:date_of_birth, :gt)).to be_a(Date)
          expect(request_params.dig(:date_of_birth, :gt)).to eq(Date.parse(date_of_birth))
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
          subject
          expect(request_params.dig(:created_at, :lt)).to be_a(Time)
          expect(request_params.dig(:created_at, :lt)).to eq(Time.at(created_at.to_i))
        end
      end
    end
  end
end
