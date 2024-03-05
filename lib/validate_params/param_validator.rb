# frozen_string_literal: true

require "active_support/inflector"

module ValidateParams
  module Validatable
    class ParamValidator
      def self.call(**args)
        new(**args).call
      end

      attr_reader :validation

      def initialize(validation:, value:, errors:)
        @validation = validation
        @value = value
        @errors = errors
        @options = validation.options.presence || {}
      end

      def call
        return if @value.blank? && !@options[:required]

        if @value.blank? && @options[:required]
          @errors << { message: required_error_message }
          return
        end

        send(validation.type.to_s.underscore)
      end

      private
        def array
          return if Types::Array.valid?(@value, **@options)

          @errors << { message: error_message }
        end

        def date
          if !Types::Date.valid?(@value)
            @errors << { message: error_message }
            return
          end

          formatted_value = Types::Date.cast(@value)

          validate_min(formatted_value) if @options[:min].present?
          validate_max(formatted_value) if @options[:max].present?
        end

        def date_time
          if !Types::DateTime.valid?(@value)
            @errors << { message: error_message }
            return
          end

          formatted_value = Types::DateTime.cast(@value)

          validate_min(formatted_value) if @options[:min].present?
          validate_max(formatted_value) if @options[:max].present?
        end

        def integer
          unless Types::Integer.valid?(@value)
            @errors << { message: error_message }
            return
          end

          formatted_value = Types::Integer.cast(@value)

          validate_inclusion if @options[:in].present?
          validate_min(formatted_value) if @options[:min].present?
          validate_max(formatted_value) if @options[:max].present?
        end

        def float
          unless Types::Float.valid?(@value)
            @errors << { message: error_message }
            return
          end

          formatted_value = Types::Float.cast(@value)

          validate_inclusion if @options[:in].present?
          validate_min(formatted_value) if @options[:min].present?
          validate_max(formatted_value) if @options[:max].present?
        end

        def string
          validate_inclusion if @options[:in].present?
        end

        def io
          unless Types::IO.valid?(@value)
            @errors << { message: error_message }
            return
          end

          io_size = @value.size

          validate_min(io_size) if @options[:min].present?
          validate_max(io_size) if @options[:max].present?
        end

        def validate_inclusion
          return if @options[:in].include?(@value)

          @errors << {
            message: I18n.t("validate_params.invalid_in", param: error_param_name),
            valid_values: @options[:in]
          }
        end

        def validate_min(value)
          return if @options[:min] <= value

          @errors << {
            message: I18n.t("validate_params.less_than_min", param: error_param_name),
            min: @options[:min]
          }
        end

        def validate_max(value)
          return if @options[:max] >= value

          @errors << {
            message: I18n.t("validate_params.more_than_max", param: error_param_name),
            max: @options[:max]
          }
        end

        def error_param_name
          if validation.parent
            "#{validation.parent.field}[#{validation.field}]"
          else
            validation.field
          end
        end

        def error_message
          I18n.t("validate_params.invalid_type", param: error_param_name, type: validation.type)
        end

        def required_error_message
          I18n.t("validate_params.required", param: error_param_name)
        end
    end
  end
end
