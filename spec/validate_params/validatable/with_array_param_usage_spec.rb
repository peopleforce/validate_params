# frozen_string_literal: true

require "fixtures/controllers/with_array_params_controller"

RSpec.describe ValidateParams::Validatable do
  subject { ctrl.run_callbacks }

  let(:user_ids) { [1, 2, 3] }
  let(:team_ids) { %w[main support] }
  let(:states) { %i[active inactive] }
  let(:array_of_hashes) { [{ name: "Test1", age: 20 }, { name: "Test2", age: 30 }] }
  let(:hash_of_hashes) do
    {
      name: "Test1",
      age: 20,
      additional: {
        name2: "Test2",
        age2: 30
      }
    }
  end

  let(:request_params) do
    {
      user_ids: user_ids,
      team_ids: team_ids,
      states: states,
      array_of_hashes: array_of_hashes,
      hash_of_hashes: hash_of_hashes
    }
  end

  context "with symbol param name" do
    let(:ctrl) { WithArrayParamsController.new(request_params) }

    describe "before_actions" do
      context "when all params are present" do
        it "returns success" do
          subject

          expect(request_params[:user_ids]).to eq(user_ids)
          expect(request_params[:team_ids]).to eq(team_ids)
          expect(request_params[:hash_of_hashes]).to eq(hash_of_hashes)
          expect(request_params[:array_of_hashes]).to eq(array_of_hashes)
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

      shared_examples "returns failure" do
        it { expect(subject).to match hash_including(json: hash_including(success: false)) }
      end

      context "when user_ids is array of words" do
        let(:user_ids) { %w[one two] }

        it_behaves_like "returns failure"
      end

      context "when user_ids is string" do
        let(:user_ids) { "one" }

        it_behaves_like "returns failure"
      end

      context "when team_ids isn't string" do
        let(:team_ids) { [1] }

        it_behaves_like "returns failure"
      end

      context "when array_of_hashes is string" do
        let(:array_of_hashes) { "string" }

        it_behaves_like "returns failure"
      end

      context "when array_of_hashes is array of strings" do
        let(:array_of_hashes) { %w[string1 string2] }

        it_behaves_like "returns failure"
      end

      context "when array_of_hashes is array of hashes with invalid values" do
        let(:array_of_hashes) { [{ name: 100, age: "invalid" }] }

        it_behaves_like "returns failure"
      end

      context "when array_of_hashes is array of ActionController::Parameters" do
        let(:array_of_hashes) do
          [
            ActionController::Parameters.new(name: "Test1", age: 20),
            ActionController::Parameters.new(name: "Test2", age: 30)
          ]
        end

        it "returns success" do
          subject
          expect(request_params[:array_of_hashes]).to eq(array_of_hashes)
        end

        context "with invalid values" do
          let(:array_of_hashes) do
            [
              ActionController::Parameters.new(name: 100, age: "invalid"),
              ActionController::Parameters.new(name: "Test2", age: 30)
            ]
          end

          it_behaves_like "returns failure"
        end
      end

      context "when hash_of_hashes is ActionController::Parameters" do
        let(:hash_of_hashes) do
          ActionController::Parameters.new(
            name: "Test1",
            age: 20,
            additional: ActionController::Parameters.new(name2: "Test2", age2: 30)
          )
        end

        it "returns success" do
          subject
          expect(request_params[:hash_of_hashes]).to eq(hash_of_hashes)
        end

        context "with invalid values" do
          let(:hash_of_hashes) do
            ActionController::Parameters.new(
              name: 100,
              age: "invalid",
              additional: ActionController::Parameters.new(
                name2: 100500,
                age2: "invalid2"
              )
            )
          end

          it_behaves_like "returns failure"
        end
      end
    end
  end
end
