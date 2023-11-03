# frozen_string_literal: true

module ValidateParams
  class Types
    class IO
      def self.valid?(value)
        value.class.method_defined?(:size)
      end

      def self.cast(raw_value, **)
        return nil if raw_value.empty?

        raw_value
      end
    end
  end
end
