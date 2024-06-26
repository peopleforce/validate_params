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
              children.each do |child|
                child_value = value[child.field] if value.is_a?(Hash) || value.is_a?(ActionController::Parameters)
                child.valid?(child_value, errors)
              end
            when "Array"
              values = value ? Array.wrap(value) : [nil]
              values.each do |item|
                children.each do |child|
                  child_value = item[child.field] if item.is_a?(Hash) ||
                    item.is_a?(ActionController::Parameters) ||
                    item.is_a?(Array)
                  child.valid?(child_value, errors)
                end
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
        options = ValidateParams::Validatable.configuration.to_h.merge(options)
        validation = Validation.new(field, type, options, [], @parent)

        if block_given?
          if ![Array, Hash].include?(type)
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
