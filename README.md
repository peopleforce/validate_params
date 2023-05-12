# ValidateParams

[![Rspec](https://github.com/peopleforce/validate_params/actions/workflows/rspec.yml/badge.svg)](https://github.com/peopleforce/validate_params/actions/workflows/rspec.yml)

ValidateParams is a lightweight, robust Ruby on Rails gem that introduces a simple yet powerful DSL (Domain Specific Language) to validate parameters for your controller actions. It is designed to make your code cleaner, more maintainable, and ensures that your application handles invalid or unexpected parameters gracefully.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add validate_params

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install validate_params

## Usage

Definition of the validator with symbols as keys:

```ruby
class TestController < ActionController::Base
  include ValidateParams::ParamsValidator

  validate_params :index do |p|
    p.param :occurred_on, Date, required: true
    p.param :quantity, Integer
    p.param :date_of_birth, Hash do |pp|
      pp.param :gt, Date
      pp.param :lt, Date
    end
    p.param :created_at, Hash do |pp|
      pp.param :lt, DateTime
      pp.param :gt, DateTime
    end
  end

  def index
    ...
  end
end
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/peopleforce/validate_params.

## Credits

Built by the team at [PeopleForce](https://peopleforce.io), the HRM for small to medium sized tech businesses.
