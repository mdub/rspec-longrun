require "rspec/core/formatters/base_formatter"

module RSpec
  module Stepper

    class Formatter < RSpec::Core::Formatters::BaseTextFormatter

      def initialize(output)
        super(output)
        @indent_level = 0
      end

      def example_group_started(example_group)
        emit(example_group.description.strip)
        @indent_level += 1
      end

      def example_group_finished(example_group)
        @indent_level -= 1
      end

      private

      def emit(message)
        output.puts(message.gsub(/^/, current_indentation))
      end

      def current_indentation
        '  ' * @indent_level
      end

    end

  end
end
