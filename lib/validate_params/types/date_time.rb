# frozen_string_literal: true

module ValidateParams
  class Types
    class DateTime
      def self.valid?(value)
        parsed_time = Time.at(Integer(value))
        return false if parsed_time.year > 9999

        true
      rescue ArgumentError, TypeError
        false
      end

      def self.cast(raw_value, **)
        return raw_value if raw_value.is_a?(::Time)

        Time.at(Integer(raw_value))
      rescue ArgumentError, TypeError
        raw_value
      end
    end
  end
end
