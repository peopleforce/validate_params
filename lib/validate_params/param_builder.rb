# frozen_string_literal: true

module ValidateParams
  module Validatable
    class ParamBuilder
      def initialize(parent_field = nil)
        @parent_field = parent_field
        @params_validations = []
      end

      def param(field, type, options = {})
        return { field: field, type: type, options: options } if @parent_field.nil?

        @params_validations << { field: { @parent_field => field }, type: type, options: options }
        @params_validations
      end
    end
  end
end
