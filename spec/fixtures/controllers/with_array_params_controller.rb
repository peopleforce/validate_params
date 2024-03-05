# frozen_string_literal: true

require_relative "base_test_controller"

class WithArrayParamsController < BaseTestController
  validate_params_for :index, format: :json do |p|
    p.param :user_ids, Array, of: Integer
    p.param :points, Array, of: Float
    p.param :team_ids, Array, of: String, reject_blank: true
    p.param :states, Array, of: Symbol, reject_blank: true
    p.param :hash_of_hashes, Hash do |pp|
      pp.param :name, String
      pp.param :age, Integer
      pp.param :additional, Hash do |ppp|
        ppp.param :name2, String
        ppp.param :age2, Integer
      end
    end
    p.param :array_of_hashes, Array, of: Hash do |pp|
      pp.param :name, String
      pp.param :age, Integer
    end
  end

  def index
    "success"
  end
end
