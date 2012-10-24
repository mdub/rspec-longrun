# RSpec::Longrun

RSpec is a fine unit-testing framework, but is also handy for acceptance and integration tests.  But the default report formatters make it difficult to track progress of such long-running tests.

The RSpec::Longrun::Formatter outputs the name of each test as it starts, rather than waiting until it passes or fails.  It also provides a mechanism for reporting on progress of a test while it is still executing.

## Installation

Add this line to your application's Gemfile:

    gem 'rspec-longrun'

In a Rails project, you can safely limit it to the "test" group.

## Usage

### Running tests

Specify the custom output format when invoking RSpec, as follows:

    rspec -r rspec/longrun -f RSpec::Longrun::Formatter spec ...

The resulting test output looks something like:

    Example group
      First example
        PASSED
      Second example
        FAILED
      Third example
        PENDING (Not implemented yet)

### Tracking progress

RSpec::Longrun defines a 'step' method that can be used to group blocks of code within the context of a large test.  For example:

    example "Log in and alter preferences" do

      step "Log in" do
        # ...
      end

      step "Navigate to preferences page" do
        # ...
      end

      step "Change preferences" do
        # ...
      end

    end

The resulting test output looks something like:

    Log in and alter preferences
      - Log in
      - Navigate to preferences page
      - Change preferences

## Contributing

rspec-longrun is on Github. You know what to do.
