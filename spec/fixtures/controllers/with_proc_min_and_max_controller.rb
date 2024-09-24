# frozen_string_literal: true

require_relative "base_test_controller"

class WithProcMinAndMaxController < BaseTestController
  validate_params_for :index, format: :json do |p|
    p.param :date_of_birth, Date, min: proc { Date.new(2020, 1, 1) }, max: proc {  Date.new(2025, 1, 1) }
    p.param :created_at, DateTime, min: proc { DateTime.new(2020, 1, 1, 12, 30) }, max: proc { DateTime.new(2025, 1, 1, 12, 30) }
    p.param :quantity, Integer, min: proc { 1 }, max: proc { 10 }
  end

  def index
    "success"
  end
end
