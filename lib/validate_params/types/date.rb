module ValidateParams
  class Types
    class Date
      def self.valid?(value)
        value = value.to_s
        return false if !/\d{4}-\d{2}-\d{2}/.match?(value)

        parsed_date = begin
                        ::Date.strptime(value, "%Y-%m-%d")
                      rescue StandardError
                        nil
                      end
        return false if parsed_date.nil?
        return false if parsed_date.year > 9999
        true
      end
    end
  end
end