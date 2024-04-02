# frozen_string_literal: true

require_relative "base_test_controller"

class WithStringController < BaseTestController
  validate_params_for [:index, :create], format: :json do |p|
    p.param :with_scrub, String, scrub_invalid_utf8: true
    p.param :without_scrub, String, scrub_invalid_utf8: false
    p.param :default, String
  end

  def index
    "success"
  end
end
