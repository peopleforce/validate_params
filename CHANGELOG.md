## [Unreleased]

## [0.13.0] - 2024-04-11

- Added `:scrub_invalid_utf8` and `:scrub_invalid_utf8_replacement` options to String type to handle invalid UTF-8 characters.
- Added [configurator](README.md#configuration) to change default behaviour for certain options.

## [0.12.1] - 2024-03-05

- Fixed support of ActionController::Parameters along with Hash

## [0.12.0] - 2024-03-05

- Added support of array of hashes
- Improved nested attributes validation

## [0.11.0] - 2023-11-04

- Added support for Float type
- Improved validation for Array type

## [0.10.0] - 2023-08-28

- Added support for IO type to validate file uploads

## [0.9.0] - 2023-08-02

- Add :min and :max options to validate param values for Integer types

## [0.8.0] - 2023-05-30

- Added support for passing array of actions into validate_params_for to run on multiple actions
- Added support for Array type to use option reject_blank: true to remove blank values from array

## [0.7.0] - 2023-05-30

- Added type support for casting params into types
- Added support for Array of types [String, Integer]

## [0.5.2] - 2023-05-29

- Support to handle HTML and JSON response formats

## [0.5.0] - 2023-05-15

- Support for Proc as options for default to set param default values
- Add :in options to validate param values against a list of values for String and Integer types
- Updated JSON formats of error messages to be more consistent

## [0.3.0] - 2023-05-12

- Add required attribute support

## [0.1.0] - 2023-05-10

- Initial release
