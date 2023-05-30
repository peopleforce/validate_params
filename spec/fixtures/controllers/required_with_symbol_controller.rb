# frozen_string_literal: true

require_relative "base_test_controller"

class RequiredWithSymbolController < BaseTestController
  validate_params_for :index, format: :json do |p|
    p.param :quantity, Integer, required: true
    p.param :date_of_birth, Date, required: true
    p.param :created_at, DateTime, required: true
    p.param :states, Array, required: true
  end

  def index
    "success"
  end
end
