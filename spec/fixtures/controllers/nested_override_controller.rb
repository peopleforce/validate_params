# frozen_string_literal: true

require_relative "with_min_and_max_controller"

class NestedOverrideController < WithMinAndMaxController
  validate_params_for :index, format: :json do |p|
    p.param :date_of_birth, Date, min: Date.new(2024, 1, 1), max: Date.new(2025, 1, 1)
  end

  def index
    "success"
  end
end
