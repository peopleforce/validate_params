# ValidateParams

[![Rspec](https://github.com/peopleforce/validate_params/actions/workflows/rspec.yml/badge.svg)](https://github.com/peopleforce/validate_params/actions/workflows/rspec.yml)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/validate_params`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add validate_params

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install validate_params

## Usage

```ruby
class TestController < ActionController::Base
  include ValidateParams::ParamsValidator

  validate_params_for :index do |p|
    p.param :id_param, Integer
    p.param :date_param, Date
    p.param :datetime_param, DateTime
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

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/validate_params.
