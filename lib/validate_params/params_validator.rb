require "active_support/concern"

module ValidateParams
  module ParamsValidator
    extend ::ActiveSupport::Concern

    included do
      before_action :set_params_defaults
      before_action :perform_validate_params
    end

    class_methods do
      attr_accessor :params_validations, :method

      def param(field, type, required: false, default: nil, &block)
        @params_validations ||= []
        @params_validations <<
          if block
            yield(ParamBuilder.new(field))
          else
            ParamBuilder.new.param(field, type, required: required, default: default)
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

    def build_error_message(field, type, value)
      I18n.t("validate_params.invalid", field: field, type: type, value: value)
    end

    def build_required_message(field)
      I18n.t("validate_params.required", field: field)
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
        next if params_validation[:default].blank?

        if params_validation[:field].is_a?(Hash)
          params_validation[:field].each_key do |key|
            next if params.dig(key, params_validation[:field][key])

            params.merge!(key => { params_validation[:field][key] => params_validation[:default] })
          end
        else
          params[params_validation[:field]] ||= params_validation[:default]
        end
      end
    end

    def perform_validate_params
      return unless request_action.present? && request_action == action_name.to_sym

      errors = []

      for params_validation in params_validations
        parameter_value = if params_validation[:field].is_a? Hash
                            params.dig(params_validation[:field].keys.first,
                                       params_validation[:field][params_validation[:field].keys.first])
                          else
                            params[params_validation[:field]]
                          end

        next if parameter_value.blank? && !params_validation[:required]

        if parameter_value.blank? && params_validation[:required]
          errors << build_required_message(error_param_name(params_validation[:field]))
          next
        end

        case params_validation[:type].to_s
        when "Date"
          if invalid_date?(parameter_value)
            errors << build_error_message(
              error_param_name(params_validation[:field]),
              params_validation[:type],
              parameter_value
            )
          end
        when "DateTime"
          if invalid_datetime?(parameter_value)
            errors << build_error_message(
              error_param_name(params_validation[:field]),
              params_validation[:type],
              parameter_value
            )
          end
        when "Integer"
          if invalid_integer?(parameter_value)
            errors << build_error_message(
              error_param_name(params_validation[:field]),
              params_validation[:type],
              parameter_value
            )
          end
        end
      end

      return if errors.empty?

      render json: { success: false, errors: errors }, status: :unprocessable_entity
    end

    def invalid_date?(value)
      return true unless /\d{4}-\d{2}-\d{2}/.match?(value)

      parsed_date = begin
        Date.strptime(value, "%Y-%m-%d")
      rescue StandardError
        nil
      end
      parsed_date.blank? || parsed_date.year > 9999
    end

    def invalid_datetime?(value)
      Time.at(Integer(value))
      false
    rescue ArgumentError, TypeError
      true
    end

    def invalid_integer?(value)
      value !~ /\A[-+]?[0-9]+\z/
    end

    class ParamBuilder
      def initialize(parent_field = nil)
        @parent_field = parent_field
      end

      def param(field, type, required: false, default: nil)
        if @parent_field
          { field: { @parent_field => field }, type: type, required: required, default: default }
        else
          { field: field, type: type, required: required, default: default }
        end
      end
    end
  end
end
