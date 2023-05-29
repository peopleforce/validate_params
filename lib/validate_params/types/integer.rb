module ValidateParams
  class Types
    class Integer
      def self.valid?(value)
        value = value.to_s
        /\A[-+]?\d+\z/ === value
      end
    end
  end
end