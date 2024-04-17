module ValidateParams
  class Configuration
    attr_accessor :scrub_invalid_utf8, :scrub_invalid_utf8_replacement

    def initialize
      @scrub_invalid_utf8 = false
      @scrub_invalid_utf8_replacement = ""
    end

    def to_h
      {
        scrub_invalid_utf8: scrub_invalid_utf8,
        scrub_invalid_utf8_replacement: scrub_invalid_utf8_replacement,
      }
    end
  end
end
