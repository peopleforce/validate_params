module ValidateParams
  module Validatable
    module Utilities
      class Scrubber
        def self.scrub(input_string, replacement: Validatable.configuration.scrub_invalid_utf8_replacement)
          input_string
            .scrub(replacement)
            .tr("\u0000", replacement)
        end
      end
    end
  end
end
