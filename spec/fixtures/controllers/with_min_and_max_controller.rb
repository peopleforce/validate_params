# frozen_string_literal: true

require_relative "base_test_controller"

class WithMinAndMaxController < BaseTestController
  validate_params_for :index, format: :json do |p|
    p.param :date_of_birth, Date, min: Date.new(2020, 1, 1), max: Date.new(2025, 1, 1)
    p.param :created_at, DateTime, min: DateTime.new(2020, 1, 1, 12, 30), max: DateTime.new(2025, 1, 1, 12, 30)
    p.param :quantity, Integer, min: 1, max: 10
  end

  def index
    "success"
  end
end
