# frozen_string_literal: true

require_relative "with_min_and_max_controller"

class NestedController < WithMinAndMaxController
  def index
    "success"
  end
end
