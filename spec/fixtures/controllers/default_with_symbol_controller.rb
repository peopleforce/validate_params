# frozen_string_literal: true

require_relative "base_test_controller"

class DefaultWithSymbolController < BaseTestController
  validate_params_for :index, format: :json do |p|
    p.param :quantity, Integer, default: 1234
    p.param :date_of_birth, Date, default: "2022-01-01"
    p.param :created_at, DateTime, default: "1683749410"
  end

  def index
    "success"
  end
end
