# ValidateParams

[![Rspec](https://github.com/peopleforce/validate_params/actions/workflows/rspec.yml/badge.svg)](https://github.com/peopleforce/validate_params/actions/workflows/rspec.yml)

ValidateParams is a lightweight, robust Ruby on Rails gem that introduces a simple yet powerful DSL (Domain Specific Language) to validate and type cast the parameters for your controller actions. It is designed to make your code cleaner, more maintainable, and ensures that your application handles invalid or unexpected parameters gracefully.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add validate-params

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install validate-params


## Configuration

To configure default options, create `config/initializers/validate_params.rb` file. Configuration example:

```ruby
Rails.application.config.after_initialize do
    ValidateParams::Validatable.configure do |config|
      config.scrub_invalid_utf8 = true # Default: false
      config.scrub_invalid_utf8_replacement = "�" # Default: empty string
    end
end
```
Currently only these options are supported in configuration. If you need more options, please create an issue.

**Be aware**: `scrub_invalid_utf8` mutates parameters value passed into controller. Learn more in [params mutation](#params-mutation) section.

## Usage

Definition of the validator with symbols as keys:

```ruby
class TestController < ActionController::Base
  include ValidateParams::Validatable

  validate_params :index do |p|
    p.param :name, String, default: "John Doe"
    p.param :occurred_on, Date, required: true, default: proc { Date.today }
    p.param :per_page, Integer, default: 50, min: 1, max: 50
    p.param :quantity, Integer, required: true, in: [1, 2, 3]
    p.param :weight, Float
    p.param :user_ids, Array, of: Integer, default: [1, 2, 3]
    p.param :states, Array, of: String, default: ["active", "inactive"], reject_blank: true
    p.param :file, IO, min: 1.byte, max: 1.megabyte
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

### Types

Here are the following supported types along with operations supported.

- String (required, default, scrub_invalid_utf8, scrub_invalid_utf8_replacement)
- Integer (required, default, min, max, in)
- Float (required, default, min, max, in)
- Date (required, default, min, max)
- DateTime (required, default, min, max)
- IO (required, min, max)
- Array of: (String|Integer|Float) (default, reject_blank)
- Hash - Nested block of types


### Params mutation

String type supports `scrub_invalid_utf8` and `scrub_invalid_utf8_replacement` options to handle invalid UTF-8 characters.
If `scrub_invalid_utf8` is set to true, it will replace invalid UTF-8 characters with the value of `scrub_invalid_utf8_replacement`.

This modified value will be passed to the controller parameters.


## Response

If the parameters are valid, the controller action will be executed as normal. If the parameters are invalid, a **400 Bad Request** response will be returned with a JSON body containing the errors, or an empty HTML response.

### JSON (Default)

```json
{
    "success": false,
    "errors": [
        {
            "message": "hired_on must be a valid Date"
        },
        {
            "message": "per_page cannot be more than maximum",
            "max": 50
        },
        {
            "message": "states is an invalid value",
            "valid_values": ["active", "inactive"]
        }
    ]
}
```

### HTML

By default responses are returned in JSON format. To return responses as an empty HTML response with a **400 Bad Request** status, change the :format option in the validate_params methods to **:html**.

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
