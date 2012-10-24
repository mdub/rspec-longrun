require "rspec/core/formatters/base_text_formatter"

module RSpec
  module Longrun

    class Formatter < RSpec::Core::Formatters::BaseTextFormatter

      def initialize(output)
        super(output)
        @indent_level = 0
      end

      def example_group_started(example_group)
        super(example_group)
        emit(example_group.description.strip)
        indent!
      end

      def example_group_finished(example_group)
        super(example_group)
        outdent!
      end

      def example_started(example)
        super(example)
        emit(example.description.strip)
        indent!
      end

      def example_passed(example)
        super(example)
        emit(green("PASSED"))
        outdent!
      end

      def example_pending(example)
        super(example)
        emit(yellow("PENDING (#{example.execution_result[:pending_message]})"))
        outdent!
      end

      def example_failed(example)
        super(example)
        emit(red("FAILED"))
        outdent!
      end

      def step_started(description)
        emit('- ' + description)
        indent!
      end

      def step_finished(description)
        outdent!
      end

      private

      def indent!
        @indent_level += 1
      end

      def outdent!
        @indent_level -= 1
      end

      def emit(message)
        output.puts(message.gsub(/^/, current_indentation))
      end

      def current_indentation
        '  ' * @indent_level
      end

    end

  end
end
