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
        start_block(example_group.description)
      end

      def example_group_finished(example_group)
        super(example_group)
        end_block
      end

      def example_started(example)
        super(example)
        start_block('* ' + cyan(example.description))
      end

      def example_passed(example)
        super(example)
        end_block(green("OK"))
      end

      def example_pending(example)
        super(example)
        end_block(yellow("PENDING: " + example.execution_result[:pending_message]))
      end

      def example_failed(example)
        super(example)
        end_block(red("FAILED"))
      end

      def step_started(description)
        start_block(faint('- ' + description))
      end

      def step_finished(description)
        end_block
      end

      private

      def start_block(message)
        emit(message.strip)
        @indent_level += 1
      end

      def end_block(message = nil)
        emit(message.strip) if message
        @indent_level -= 1
      end

      def emit(message)
        output.puts(message.gsub(/^/, current_indentation))
      end

      def current_indentation
        '  ' * @indent_level
      end

      def faint(text)
        color(text, "\e[2m")
      end

    end

  end
end
