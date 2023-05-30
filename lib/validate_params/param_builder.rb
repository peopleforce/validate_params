# frozen_string_literal: true

module ValidateParams
  module Validatable
    class ParamBuilder
      def initialize(parent_field: nil, validations:)
        @parent_field = parent_field
        @validations = validations
      end

      def param(field, type, options = {}, &block)
        if block
          yield(ParamBuilder.new(parent_field: field, validations: @validations))
        else
          @validations << build_config(field, type, options)
        end
      end

      private
        def build_config(field, type, options)
          if @parent_field.nil?
            { field: field, type: type, options: options }
          else
            { field: { @parent_field => field }, type: type, options: options }
          end
        end
    end
  end
end
