# frozen_string_literal: true

module ValidateParams
  class Types
    class IO
      def self.valid?(value)
        value.class.method_defined?(:size)
      end

      def self.cast(raw_value, **)
        raw_value.size
      end
    end
  end
end
