# frozen_string_literal: true

module ValidateParams
  class Types
    class Integer
      def self.valid?(value)
        /\A[-+]?\d+\z/ === value.to_s
      end

      def self.cast(raw_value, **)
        raw_value.to_i
      end
    end
  end
end
