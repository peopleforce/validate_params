module ValidateParams
  class Types
    class DateTime
      def self.valid?(value)
        Time.at(Integer(value))
        true
      rescue ArgumentError, TypeError
        false
      end
    end
  end
end