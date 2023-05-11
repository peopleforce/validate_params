# frozen_string_literal: true

require_relative "validate_params/version"
require_relative "validate_params/params_validator"

module ValidateParams
  class Error < StandardError; end
end

ActiveSupport.on_load(:action_controller) do
  include ValidateParams::ParamsValidator
end
