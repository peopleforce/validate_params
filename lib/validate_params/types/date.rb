# frozen_string_literal: true

module ValidateParams
  class Types
    class Date
      FORMAT = "%Y-%m-%d"

      def self.valid?(value)
        value = value.to_s
        return false unless /\d{4}-\d{2}-\d{2}/.match?(value)

        parsed_date = begin
          ::Date.strptime(value, FORMAT)
        rescue StandardError
          nil
        end
        return false if parsed_date.nil?
        return false if parsed_date.year > 9999

        true
      end

      def self.cast(raw_value, **)
        return raw_value if raw_value.is_a?(::Date)

        ::Date.strptime(raw_value.to_s, FORMAT)
      rescue StandardError
        raw_value
      end
    end
  end
end
