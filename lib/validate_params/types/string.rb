# frozen_string_literal: true

module ValidateParams
  class Types
    class String
      def self.cast(raw_value)
        raw_value.to_s
      end
    end
  end
end
