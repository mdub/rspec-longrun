# RSpec::Longrun

[![Gem Version](https://badge.fury.io/rb/rspec-longrun.png)](http://badge.fury.io/rb/rspec-longrun)
[![Build Status](https://secure.travis-ci.org/mdub/rspec-longrun.png?branch=master)](http://travis-ci.org/mdub/rspec-longrun)

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

    Example group {
      First example OK (1.2s)
      Second example OK (3.4s)
      Third example PENDING (Not implemented yet) (0.2s)
    } (5.2s)

(though a little more colourful).

### Tracking progress

Include RSpec::Longrun::DSL to define the 'step' method, which can be used to group blocks of code within the context of a large test.  For example:

    describe "Account management" do

      include RSpec::Longrun::DSL     # <-- important

      example "Log in and alter preferences" do

        step "Log in" do
          ui.go_home
          ui.authenticate_as "joe", "fnord"
        end

        step "Navigate to preferences page" do
          ui.nav.prefs_link.click
        end

        step "Change preferences" do
          ui.prefs_pane.enter_defaults
          ui.prefs_pane.save
        end

      end

    end

The resulting test output looks something like:

    Account management {
      Log in and alter preferences {
        Log in (0.5s)
        Navigate to preferences page (0.2s)
        Change preferences (5.2s)
      } OK (7.1s)
    } OK (7.2s)

which gives you some extra context in the event that something fails, or hangs, during the test run.

## Contributing

rspec-longrun is on Github. You know what to do.
