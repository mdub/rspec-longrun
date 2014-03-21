require 'rspec/core'
require 'rspec/core/formatters/base_formatter'

# extend rspec-core with support for "steps"
module RSpec::Core

  class Reporter

    if defined?(NOTIFICATIONS)
      NOTIFICATIONS.push("step_started", "step_finished")
    end

    def step_started(description)
      notify :step_started, description
    end

    def step_finished(description)
      notify :step_finished, description
    end

  end

  unless defined?(Reporter::NOTIFCATIONS)

    class Formatters::BaseFormatter

      def step_started(description)
      end

      def step_finished(description)
      end

    end

  end

  class Example

    private

    alias :start_without_reporter :start

    def start(reporter)
      start_without_reporter(reporter)
      @example_group_instance.instance_variable_set(:@_rspec_reporter, reporter)
    end

  end

end
