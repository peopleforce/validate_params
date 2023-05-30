# frozen_string_literal: true

module ValidateParams
  class Types
    class Array
      def self.valid?(value, of: String, reject_blank: false, **)
        val = value
        val = val.reject(&:blank?) if reject_blank

        case of.to_s
        when "Integer"
          val.all? { |item| Types::Integer.valid?(item) }
        else
          true
        end
      end

      def self.cast(raw_value, of: String, reject_blank: false, **)
        value = raw_value
        value = value.reject!(&:blank?) if reject_blank

        case of.to_s
        when "Integer"
          value.map { |item| Types::Integer.cast(item) }
        else
          value
        end
      end
    end
  end
end
