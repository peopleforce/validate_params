# frozen_string_literal: true

require_relative "base_test_controller"

class WithSymbolController < BaseTestController
  validate_params_for :index, format: :json do |p|
    p.param :quantity, Integer
    p.param :date_of_birth, Date
    p.param :created_at, DateTime
    p.param :user_ids, Array, of: Integer
  end

  def index
    "success"
  end
end
