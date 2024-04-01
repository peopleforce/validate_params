# frozen_string_literal: true

require "validate_params/utilities/scrubber"

module ValidateParams
  class Types
    class String
      def self.cast(raw_value, **options)
        value = raw_value.to_s

        if options[:scrub_invalid_utf8]
          value = Validatable::Utilities::Scrubber.scrub(raw_value)
        end

        value
      end
    end
  end
end
