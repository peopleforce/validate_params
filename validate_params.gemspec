# frozen_string_literal: true

require_relative "lib/validate_params/version"

Gem::Specification.new do |spec|
  spec.license = "MIT"
  spec.name = "validate-params"
  spec.version = ValidateParams::VERSION
  spec.authors = ["dcherevatenko"]
  spec.email = ["denis.cherevatenko@peopleforce.io "]

  spec.summary = "Gem to validate params in controllers"
  spec.description = "Provides a clean DSL to validate params for controller actions."
  spec.required_ruby_version = ">= 2.7.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "actionpack", ">= 6.1.0"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "activesupport", ">= 6.1.0"
  spec.add_dependency "i18n", ">= 1.6"
end
