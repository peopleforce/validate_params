# frozen_string_literal: true

require "validate_params/types/date"
require "validate_params/types/date_time"
require "validate_params/types/integer"
require "validate_params/types/array"
require_relative "param_builder"
require_relative "param_validator"

require "active_support/concern"

module ValidateParams
  module Validatable
    extend ::ActiveSupport::Concern

    included do
      before_action :set_params_defaults
      before_action :perform_validate_params
    end

    class_methods do
      attr_accessor :params_validations, :method

      def param(field, type, options = {}, &block)
        @params_validations ||= []

        if block
          param_builder = ParamBuilder.new(field)
          @params_validations += yield(param_builder)
        else
          @params_validations << ParamBuilder.new.param(field, type, options)
        end
      end

      def validate_params_for(controller_action, options = {}, &block)
        @controller_action = controller_action
        @response_format = options[:format] || :json

        yield(self) if block
      end
    end

    def params_validations
      self.class.instance_variable_get(:@params_validations) || []
    end

    def controller_action
      self.class.instance_variable_get(:@controller_action) || nil
    end

    def response_format
      self.class.instance_variable_get(:@response_format) || nil
    end

    private
      def set_params_defaults
        params_validations.each do |params_validation|
          next unless params_validation[:options].key?(:default)

          if params_validation[:field].is_a?(Hash)
            params_validation[:field].each_key do |key|
              # Skip in case hash is configured and string is passed
              next if params[key].is_a? Hash
              next if params.dig(key, params_validation[:field][key])

              value = if params_validation[:options][:default].is_a?(Proc)
                        params_validation[:options][:default].call
                      else
                        params_validation[:options][:default]
                      end
              params.deep_merge!(key => { params_validation[:field][key] => value })
            end
          else
            value = if params_validation[:options][:default].is_a?(Proc)
                      params_validation[:options][:default].call
                    else
                      params_validation[:options][:default]
                    end

            params[params_validation[:field]] ||= value

          end
        end
      end

      def cast_param_values
        params_validations.each do |params_validation|
          if params_validation[:field].is_a?(Hash)
            params_validation[:field].each_key do |key|
              next unless params[key].is_a?(Hash)

              value = params.dig(key, params_validation[:field][key])
              next if value.blank?

              params.deep_merge!(
                key => {
                  params_validation[:field][key] => if params_validation[:type].name == "Array"
                                                      Types.const_get(params_validation[:type].name).cast(value,
                                                                                                          of: params_validation[:options][:of])
                                                    else
                                                      Types.const_get(params_validation[:type].name).cast(value)
                                                    end
                }
              )
            end
          else
            value = params[params_validation[:field]]
            next if value.blank?

            params[params_validation[:field]] = if params_validation[:type].name == "Array"
                                                  Types.const_get(params_validation[:type].name).cast(value, of: params_validation[:options][:of])
                                                else
                                                  Types.const_get(params_validation[:type].name).cast(value)
                                                end
          end
        end
      end

      def perform_validate_params
        return unless controller_action.present? && controller_action == action_name.to_sym

        errors = []

        params_validations.each do |params_validation|
          # Skip in case hash is configured and string is passed
          next if params_validation[:field].is_a?(Hash) &&
            params[params_validation[:field].keys.first].is_a?(String)

          parameter_value = if params_validation[:field].is_a? Hash
                              params.dig(params_validation[:field].keys.first,
                                         params_validation[:field][params_validation[:field].keys.first])
                            else
                              params[params_validation[:field]]
                            end

          ParamValidator.call(
            type: params_validation[:type],
            field: params_validation[:field],
            value: parameter_value,
            errors: errors,
            options: params_validation[:options]
          )
        end

        if errors.empty?
          cast_param_values
          return
        end

        case response_format
        when :html
          head :bad_request
        else
          render json: { success: false, errors: errors }, status: :bad_request
        end
      end
  end
end
