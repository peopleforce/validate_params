# frozen_string_literal: true

module ValidateParams
  module Validatable
    class ParamBuilder
      Validation = Struct.new(:field, :type, :options, :children, :parent) do
        def valid?(value, errors)
          ParamValidator.call(
            validation: self,
            value: value,
            errors: errors
          )

          if children.any?
            case type.to_s
            when "Hash"
              # Skip in case hash is configured and string is passed
              unless value.is_a?(String)
                children.each { |c| c.valid?(value&.[](c.field), errors) }
              end
            when "Array"
              values = value ? Array.wrap(value) : [nil]
              values.each do |item|
                children.each { |c| c.valid?(item&.[](c.field), errors) }
              end
            else
              raise "Unexpected type: #{type}"
            end
          end

          errors.empty?
        end
      end

      def initialize(parent: nil, validations: [])
        @parent = parent
        @validations = validations
      end

      def param(field, type, options = {})
        validation = Validation.new(field, type, options, [], @parent)

        if block_given?
          unless [Array, Hash].include?(type)
            raise "#{type} type cannot have nested definitions, only Array or Hash are supported"
          end

          yield ParamBuilder.new(parent: validation)
        end

        if @parent
          @parent.children << validation
        else
          @validations << validation
        end
      end
    end
  end
end
