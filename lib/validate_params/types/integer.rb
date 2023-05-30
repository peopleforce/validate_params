# frozen_string_literal: true

module ValidateParams
  class Types
    class Integer
      def self.valid?(value)
        value.to_s == /\A[-+]?\d+\z/
      end

      def self.cast(raw_value)
        raw_value.to_i
      end
    end
  end
end
