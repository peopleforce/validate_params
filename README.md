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
  include ValidateParams::Validatable

  validate_params :index do |p|
    p.param :name, String, default: "John Doe"
    p.param :occurred_on, Date, required: true, default: proc { Date.today }
    p.param :quantity, Integer, required: true, in: [1, 2, 3]
    p.param :user_ids, Array, of: Integer, default: [1, 2, 3]
    p.param :states, Array, of: String, default: ["active", "inactive"], reject_blank: true
    p.param :date_of_birth, Hash do |pp|
      pp.param :gt, Date, min: Date.new(2020, 1, 1), max: Date.new(2021, 1, 1)
      pp.param :lt, Date
    end
    p.param :created_at, Hash do |pp|
      pp.param :lt, DateTime, min: DateTime.new(2020, 1, 1), max: DateTime.new(2021, 1, 1)
      pp.param :gt, DateTime
    end
  end

  def index
    ...
  end
end
```

## Response

If the parameters are valid, the controller action will be executed as normal. If the parameters are invalid, a **400 Bad Request** response will be returned with a JSON body containing the errors, or an empty HTML response.

```json
{
    "success": false,
    "errors": [
        {
            "message": "hired_on must be a valid Date"
        },

    ]
}
```

## Format

By default responses are returned in JSON format. To return responses as an empty HTML response, change the :format options in the validate_params methods to :html.

Example:

```ruby
validate_params :index, format: :html do |p|
    p.param :name, String, default: "John Doe"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/peopleforce/validate_params.

## Credits

Built by the team at [PeopleForce](https://peopleforce.io), the HRM for small to medium sized tech businesses.
