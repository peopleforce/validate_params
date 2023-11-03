# frozen_string_literal: true

require_relative "base_test_controller"

class WithArrayParamsController < BaseTestController
  validate_params_for :index, format: :json do |p|
    p.param :user_ids, Array, of: Integer
    p.param :points, Array, of: Float
    p.param :team_ids, Array, of: String, reject_blank: true
    p.param :states, Array, of: Symbol, reject_blank: true
  end

  def index
    "success"
  end
end
