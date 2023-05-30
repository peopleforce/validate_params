# frozen_string_literal: true

require_relative "base_test_controller"

class DefaultWithHashController < BaseTestController
  validate_params_for :index, format: :json do |p|
    p.param :count, default: proc { (2 * 2) }
    p.param :quantity, Hash do |pp|
      pp.param :eq, Integer, default: 1234
    end
    p.param :date_of_birth, Hash do |pp|
      pp.param :gt, Date, default: "2022-01-01"
    end
    p.param :created_at, Hash do |pp|
      pp.param :lt, DateTime, default: "1683749410"
    end
  end

  def index
    "success"
  end
end
