# frozen_string_literal: true

require "validate_params/types/date"
require "validate_params/types/date_time"
require "validate_params/types/integer"
require "validate_params/types/array"
require "validate_params/types/string"
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

      def validate_params_for(action, options = {}, &block)
        options[:format] ||= :json
        @params_validations ||= {}

        Array(action).each do |act|
          @params_validations[act] ||= { options: options, validations: [] }

          yield(ParamBuilder.new(validations: @params_validations[act][:validations])) if block
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
          apply_default_values(validation)

          next if validation[:field].is_a?(Hash) &&
            params[validation[:field].keys.first].is_a?(String)

          parameter_value = if validation[:field].is_a? Hash
                              params.dig(validation[:field].keys.first,
                                         validation[:field][validation[:field].keys.first])
                            else
                              params[validation[:field]]
                            end

          ParamValidator.call(
            type: validation[:type],
            field: validation[:field],
            value: parameter_value,
            errors: errors,
            options: validation[:options]
          )
        end

        if errors.empty?
          cast_param_values(config[:validations])
          return
        end

        case config.dig(:options, :format)
        when :html
          head :bad_request
        else
          render json: { success: false, errors: errors }, status: :bad_request
        end
      end

      def apply_default_values(validation)
        return unless validation[:options].key?(:default)

        if validation[:field].is_a?(Hash)
          validation[:field].each_key do |key|
            # Skip in case hash is configured and string is passed
            next if hashlike?(params[key])
            next if params.dig(key, validation[:field][key])

            value = if validation[:options][:default].is_a?(Proc)
                      validation[:options][:default].call
                    else
                      validation[:options][:default]
                    end

            params[key] ||= {}
            params[key][validation[:field][key]] = value
          end
        else
          value = if validation[:options][:default].is_a?(Proc)
                    validation[:options][:default].call
                  else
                    validation[:options][:default]
                  end

          params[validation[:field]] ||= value
        end
      end

      def cast_param_values(validations)
        validations.each do |validation|
          if validation[:field].is_a?(Hash)
            validation[:field].each_key do |key|
              next unless hashlike?(params[key])

              value = params.dig(key, validation[:field][key])
              next if value.blank?

              params[key][validation[:field][key]] = Types.const_get(validation[:type].name).cast(value, **validation.fetch(:options, {}))
            end
          else
            value = params[validation[:field]]
            next if value.blank?

            params[validation[:field]] = Types.const_get(validation[:type].name).cast(value, **validation.fetch(:options, {}))
          end
        end
      end

      def hashlike?(obj)
        obj.is_a?(Hash) || obj.is_a?(ActionController::Parameters)
      end
  end
end
