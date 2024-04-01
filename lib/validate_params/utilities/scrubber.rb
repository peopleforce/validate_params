module ValidateParams
  module Validatable
    module Utilities
      class Scrubber
        def self.scrub(input_string)
          input_string
            .scrub("")
            .tr("\u0000", "")
        end
      end
    end
  end
end
