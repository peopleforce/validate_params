# frozen_string_literal: true

module ValidateParams
  class Types
    class Array
      def self.valid?(value, of: String, reject_blank: false, **)
        return false unless value.is_a?(::Array)

        val = value
        val.reject!(&:blank?) if reject_blank

        case of.to_s
        when "Integer"
          val.all? { |item| Types::Integer.valid?(item) }
        when "Float"
          val.all? { |item| Types::Float.valid?(item) }
        when "String"
          val.all? { |item| item.is_a?(::String) }
        else
          true
        end
      end

      def self.cast(raw_value, of: String, reject_blank: false, **)
        value = raw_value
        value.reject!(&:blank?) if reject_blank

        case of.to_s
        when "Integer"
          value.map { |item| Types::Integer.cast(item) }
        when "Float"
          value.map { |item| Types::Float.cast(item) }
        else
          value
        end
      end
    end
  end
end
