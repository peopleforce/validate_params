# frozen_string_literal: true

module ValidateParams
  class Types
    class Array
      def self.valid?(value, of: String)
        case of.to_s
        when "Integer"
          value.all? { |item| Types::Integer.valid?(item) }
        else
          true
        end
      end

      def self.cast(raw_value, of: String)
        case of.to_s
        when "Integer"
          raw_value.map { |item| Types::Integer.cast(item) }
        else
          raw_value
        end
      end
    end
  end
end
