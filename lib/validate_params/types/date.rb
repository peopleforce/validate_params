module ValidateParams
  class Types
    class Date
      def self.valid?(value)
        return true unless /\d{4}-\d{2}-\d{2}/.match?(value)

        parsed_date = begin
                        Date.strptime(value, "%Y-%m-%d")
                      rescue StandardError
                        nil
                      end
        parsed_date.blank? || parsed_date.year > 9999
      end
    end
  end
end