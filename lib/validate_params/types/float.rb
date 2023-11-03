# frozen_string_literal: true

module ValidateParams
  class Types
    class Float
      def self.valid?(value)
        /\A[-+]?\d+(\.\d+)?\z/ === value.to_s
      end

      def self.cast(raw_value, **)
        raw_value.to_f
      end
    end
  end
end
