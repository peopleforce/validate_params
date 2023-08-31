# frozen_string_literal: true

module ValidateParams
  class Types
    class IO
      def self.valid?(value)
        value.class.method_defined?(:size)
      end
    end
  end
end
