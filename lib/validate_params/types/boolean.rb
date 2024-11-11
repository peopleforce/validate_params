# frozen_string_literal: true

module ValidateParams
  class Types
    class Boolean
      TRUE_VALUES = [true, 1, "1", :"1", "t", :t, "T", :T, "true", :true, "TRUE", :TRUE, "on", :on, "ON", :ON].to_set.freeze
      FALSE_VALUES = [false, 0, "0", :"0", "f", :f, "F", :F, "false", :false, "FALSE", :FALSE, "off", :off, "OFF", :OFF].to_set.freeze

      def self.valid?(value)
        value.is_a?(::TrueClass) || value.is_a?(::FalseClass)
      end

      def self.cast(raw_value, **)
        return true if TRUE_VALUES.include?(raw_value)
        return false if FALSE_VALUES.include?(raw_value)

        raw_value
      end
    end
  end
end
