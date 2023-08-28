# frozen_string_literal: true

require_relative "base_test_controller"

class FileUploadController < BaseTestController
  validate_params_for :index, format: :json do |p|
    p.param :file, IO, min: 1, max: 153_600
  end

  def index
    "success"
  end
end
