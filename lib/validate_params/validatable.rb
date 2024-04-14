# frozen_string_literal: true

require "validate_params/types/date"
require "validate_params/types/date_time"
require "validate_params/types/integer"
require "validate_params/types/float"
require "validate_params/types/array"
require "validate_params/types/string"
require "validate_params/types/i_o"
require_relative "param_builder"
require_relative "param_validator"

require "active_support/concern"

module ValidateParams
  module Validatable
    extend ::ActiveSupport::Concern

    included do
      before_action :perform_validate_params
    end

    class_methods do
      attr_reader :params_validations

      def validate_params_for(action, options = {})
        options[:format] ||= :json
        @params_validations ||= {}

        Array(action).each do |act|
          @params_validations[act] ||= { options: options, validations: [] }

          if block_given?
            param_builder = ParamBuilder.new(validations: @params_validations[act][:validations])
            yield(param_builder)
          end
        end
      end
    end

    def params_validations
      self.class.params_validations || {}
    end

    private
      def perform_validate_params
        return unless params_validations.key?(action_name.to_sym)

        errors = []
        config = params_validations[action_name.to_sym]

        config[:validations].each do |validation|
          apply_default_values(params, validation)
          validation.valid?(params[validation.field], errors)
        end

        if errors.empty?
          config[:validations].each do |validation|
            cast_param_values(params, validation)
          end

          return
        end

        case config.dig(:options, :format)
        when :html
          head :bad_request
        else
          render json: { success: false, errors: errors }, status: :bad_request
        end
      end

      def apply_default_values(params, validation)
        validation.children.each do |sub_validation|
          next if sub_validation.options.blank?

          if validation.type == Array
            Array(params[validation.field]).each do |sub_params|
              apply_default_values(sub_params, sub_validation)
            end
          elsif validation.type == Hash
            # Skip in case hash is configured and string is passed
            next if params[validation.field].is_a?(String)

            params[validation.field] ||= {}
            apply_default_values(params[validation.field], sub_validation)
          else
            apply_default_values(params, sub_validation)
          end
        end

        return if validation.children.any?

        options = validation.options.presence || {}
        return if !options.key?(:default)

        value = options[:default].is_a?(Proc) ? options[:default].call : options[:default]

        if validation.type == Integer
          params[validation.field] = value if params[validation.field].blank?
        else
          params[validation.field] ||= value
        end
      end

      def cast_param_values(params, validation)
        return unless params

        validation.children.each do |sub_validation|
          if validation.type == Hash
            # Skip in case hash is configured and string is passed
            next if params[validation.field].is_a?(String)

            cast_param_values(params[validation.field], sub_validation)
          elsif validation.type == Array
            params[validation.field].each do |sub_params|
              cast_param_values(sub_params, sub_validation)
            end
          end
        end

        return if validation.children.any?

        value = params[validation.field]
        return if value.blank?

        options = validation.options.presence || {}
        params[validation.field] = Types.const_get(validation.type.name).cast(value, **options)
      end
  end
end
