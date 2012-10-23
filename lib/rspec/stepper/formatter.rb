require "rspec/core/formatters/base_formatter"

module RSpec
  module Stepper

    class Formatter < RSpec::Core::Formatters::BaseTextFormatter

      def example_group_started(example_group)
        super(example_group)
        output.puts example_group.description.strip
      end

    end

  end
end
