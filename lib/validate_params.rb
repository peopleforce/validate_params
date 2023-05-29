# frozen_string_literal: true

require_relative "validate_params/version"
require_relative "validate_params/validatable"
Dir[File.join(__dir__, 'validate_params/types', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'validate_params/validators', '*.rb')].each { |file| require file }

module ValidateParams
  class Error < StandardError; end
end

ActiveSupport.on_load(:action_controller) do
  include ValidateParams::Validatable
end
