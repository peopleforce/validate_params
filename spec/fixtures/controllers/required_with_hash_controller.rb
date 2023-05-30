# frozen_string_literal: true

require_relative "base_test_controller"

class RequiredWithHashController < BaseTestController
  validate_params_for :index, format: :json do |p|
    p.param :quantity, Hash do |pp|
      pp.param :eq, Integer, required: true
    end
    p.param :date_of_birth, Hash do |pp|
      pp.param :gt, Date, required: true
    end
    p.param :created_at, Hash do |pp|
      pp.param :lt, DateTime, required: true
    end
  end

  def index
    "success"
  end
end
