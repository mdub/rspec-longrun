require "rspec/core/formatters/base_text_formatter"

module RSpec
  module Longrun

    class Formatter < RSpec::Core::Formatters::BaseTextFormatter

      def initialize(output)
        super(output)
        @indent_level = 0
        @block_begin_times = []
      end

      def example_group_started(example_group)
        super(example_group)
        begin_block(example_group.description)
      end

      def example_group_finished(example_group)
        super(example_group)
        end_block
      end

      def example_started(example)
        super(example)
        begin_block(cyan(example.description))
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
        begin_block(description)
      end

      def step_finished(description)
        end_block
      end

      private

      def begin_block(message)
        emit(message, faint('{'))
        @indent_level += 1
        @block_begin_times.push(Time.now.to_i)
      end

      def end_block(message = nil)
        finish_time = Time.now.to_i
        begin_time = @block_begin_times.pop
        timing = '(' + format_timing(begin_time, finish_time) + ')'
        @indent_level -= 1
        emit(faint('}'), message, faint(timing))
      end

      def emit(*args)
        message = args.compact.map { |a| a.strip }.join(' ')
        output.puts(message.gsub(/^/, current_indentation))
      end

      def current_indentation
        '  ' * @indent_level
      end

      def faint(text)
        color(text, "\e[2m")
      end

      def format_timing(begin_time, finish_time)
        delta = finish_time - begin_time
        '%.2fs' % delta
      end

    end

  end
end
