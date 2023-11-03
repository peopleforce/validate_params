# frozen_string_literal: true

require "fixtures/controllers/with_array_params_controller"

RSpec.describe ValidateParams::Validatable do
  subject { ctrl.run_callbacks }

  let(:user_ids) { [1, 2, 3] }
  let(:team_ids) { %w[main support] }
  let(:states) { %i[active inactive] }
  let(:request_params) { { user_ids: user_ids, team_ids: team_ids, states: states } }

  context "with symbol param name" do
    let(:ctrl) { WithArrayParamsController.new(request_params) }

    describe "before_actions" do
      context "when all params are present" do
        it "returns success" do
          subject

          expect(request_params[:user_ids]).to eq(user_ids)
          expect(request_params[:team_ids]).to eq(team_ids)
          expect(request_params[:states]).to eq(states)
        end
      end

      context "when user_ids is array of numeric strings" do
        let(:user_ids) { %w[1 2 3] }

        it "returns success" do
          subject

          expect(request_params[:user_ids]).to eq([1, 2, 3])
          expect(request_params[:team_ids]).to eq(team_ids)
          expect(request_params[:states]).to eq(states)
        end
      end

      context "when team_ids includes empty values" do
        let(:team_ids) { ["main", "support", "", nil] }

        it "returns success" do
          subject

          expect(request_params[:user_ids]).to eq([1, 2, 3])
          expect(request_params[:team_ids]).to eq(%w[main support])
          expect(request_params[:states]).to eq(states)
        end
      end

      context "when params are empty arrays" do
        let(:user_ids) { [] }
        let(:team_ids) { [] }
        let(:states) { [] }

        it "returns failure" do
          subject

          expect(request_params[:user_ids]).to eq(user_ids)
          expect(request_params[:team_ids]).to eq(team_ids)
          expect(request_params[:states]).to eq(states)
        end
      end

      context "when params are arrays with nil" do
        let(:team_ids) { [nil] }
        let(:states) { [nil] }

        it "returns failure" do
          subject

          expect(request_params[:team_ids]).to eq([])
          expect(request_params[:states]).to eq([])
        end
      end

      context "when user_ids is array of words" do
        let(:user_ids) { %w[one two] }

        it "returns success" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false
            )
          )
        end
      end

      context "when user_ids is string" do
        let(:user_ids) { "one" }

        it "returns failure" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false
            )
          )
        end
      end

      context "when team_ids isn't string" do
        let(:team_ids) { [1] }

        it "returns failure" do
          expect(subject).to match hash_including(
            json: hash_including(
              success: false
            )
          )
        end
      end
    end
  end
end
