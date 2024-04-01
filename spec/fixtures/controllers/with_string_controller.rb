# frozen_string_literal: true

require_relative "base_test_controller"

class WithStringController < BaseTestController
  validate_params_for [:index, :create], format: :json do |p|
    p.param :title, String
    p.param :description, String
  end

  def index
    "success"
  end
end
