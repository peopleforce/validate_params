# frozen_string_literal: true

require "active_support/inflector"

module ValidateParams
  module Validatable
    class ParamValidator
      def self.call(**args)
        new(**args).call
      end

      def initialize(type:, field:, value:, errors:, options: {})
        @type = type
        @field = field
        @value = value
        @errors = errors
        @options = options
      end

      def call
        return if @value.blank? && !@options[:required]

        if @value.blank? && @options[:required]
          @errors << { message: required_error_message }
          return
        end

        send(@type.to_s.underscore)
      end

      private
        def array
          return if Types::Array.valid?(@value, **@options)

          @errors << { message: error_message }
        end

        def date
          return if Types::Date.valid?(@value)

          @errors << { message: error_message }
        end

        def date_time
          return if Types::DateTime.valid?(@value)

          @errors << { message: error_message }
        end

        def integer
          unless Types::Integer.valid?(@value)
            @errors << { message: error_message }
            return
          end

          validate_inclusion if @options[:in].present?
        end

        def string
          validate_inclusion if @options[:in].present?
        end

        def validate_inclusion
          return if @options[:in].include?(@value)

          @errors << {
            message: I18n.t("validate_params.invalid_in", param: error_param_name),
            valid_values: @options[:in]
          }
        end

        def error_param_name
          case @field
          when Array
            "#{@field[0]}[#{@field[1]}]"
          when Hash
            @field.map { |k, v| "#{k}[#{v}]" }.first
          else
            @field
          end
        end

        def error_message
          I18n.t("validate_params.invalid_type", param: error_param_name, type: @type)
        end

        def required_error_message
          I18n.t("validate_params.required", param: error_param_name)
        end
    end
  end
end
