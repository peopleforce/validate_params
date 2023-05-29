# frozen_string_literal: true

require "validate_params/types/date"
require "validate_params/types/date_time"
require "validate_params/types/integer"

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

      def validate_params_for(request_action, &block)
        @request_action = request_action

        yield(self) if block
      end
    end

    def params_validations
      self.class.instance_variable_get(:@params_validations) || []
    end

    def request_action
      self.class.instance_variable_get(:@request_action) || nil
    end

    private

    def build_error_message(param, type)
      I18n.t("validate_params.invalid_type", param: param, type: type)
    end

    def build_required_message(param)
      I18n.t("validate_params.required", param: param)
    end

    def error_param_name(field)
      case field
      when Array
        "#{field[0]}[#{field[1]}]"
      when Hash
        field.map { |k, v| "#{k}[#{v}]" }.first
      else
        field
      end
    end

    def set_params_defaults
      params_validations.each do |params_validation|
        next if params_validation[:options][:default].blank?

        if params_validation[:field].is_a?(Hash)
          params_validation[:field].each_key do |key|
            # Skip in case hash is configured and string is passed
            next if params.dig(key).is_a? Hash
            next if params.dig(key, params_validation[:field][key])

            value = if params_validation[:options][:default].is_a?(Proc)
                      params_validation[:options][:default].call
                    else
                      params_validation[:options][:default]
                    end
            params.merge!(key => { params_validation[:field][key] => value })
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

    def perform_validate_params
      return unless request_action.present? && request_action == action_name.to_sym

      errors = []

      for params_validation in params_validations
        # Skip in case hash is configured and string is passed
        next if params_validation[:field].is_a?(Hash) &&
          params.dig(params_validation[:field].keys.first).is_a?(String)

        parameter_value = if params_validation[:field].is_a? Hash
                            params.dig(params_validation[:field].keys.first,
                                       params_validation[:field][params_validation[:field].keys.first])
                          else
                            params[params_validation[:field]]
                          end

        next if parameter_value.blank? && !params_validation[:options][:required]

        if parameter_value.blank? && params_validation[:options][:required]
          errors << { message: build_required_message(error_param_name(params_validation[:field])) }
          next
        end

        case params_validation[:type].to_s
        when "Date"
          unless ValidateParams::Types::Date.valid?(parameter_value)
            errors << {
              message: build_error_message(error_param_name(params_validation[:field]), params_validation[:type])
            }
          end
        when "DateTime"
          unless ValidateParams::Types::DateTime.valid?(parameter_value)
            errors << {
              message: build_error_message(error_param_name(params_validation[:field]), params_validation[:type])
            }
          end
        when "Integer"
          unless ValidateParams::Types::Integer.valid?(parameter_value)
            errors << {
              message: build_error_message(error_param_name(params_validation[:field]), params_validation[:type])
            }
            next
          end

          parameter_value = parameter_value.to_i
          if params_validation[:options][:in].present? && !params_validation[:options][:in].include?(parameter_value)
            errors << {
              message: I18n.t("validate_params.invalid_in", param: error_param_name(params_validation[:field])),
              valid_values: params_validation[:options][:in]
            }
          end
        when "String"
          parameter_value = parameter_value.to_s
          if params_validation[:options][:in].present? && !params_validation[:options][:in].include?(parameter_value)
            errors << {
              message: I18n.t("validate_params.invalid_in", param: error_param_name(params_validation[:field])),
              valid_values: params_validation[:options][:in]
            }
          end
        end
      end

      return if errors.empty?

      if request.nil? || request.format.json?
        render json: { success: false, errors: errors }, status: :bad_request
      else
        head :bad_request
      end
    end

    class ParamBuilder
      def initialize(parent_field = nil)
        @parent_field = parent_field
        @params_validations = []
      end

      def param(field, type, options = {})
        unless @parent_field
          return { field: field, type: type, options: options }
        end

        @params_validations << { field: { @parent_field => field }, type: type, options: options }
        @params_validations
      end
    end
  end
end
