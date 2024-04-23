## [0.13.1] - 2024-04-22

- Improved checking for empty strings

## [0.13.0] - 2024-04-16

- Added `:scrub_invalid_utf8` and `:scrub_invalid_utf8_replacement` options to String type to handle invalid UTF-8 characters
- Added [configurator](README.md#configuration) to change default behaviour for certain options

## [0.12.5] - 2024-04-15

- Restrict validation rules for Hash type objects

## [0.12.4] - 2024-04-14

- Revert 0.12.2 changes

## [0.12.3] - 2024-04-14

- Default option for Integer type should support empty string as well

## [0.12.2] - 2024-03-11

- Added inheritance of validate params rule between child and parent controllers

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
