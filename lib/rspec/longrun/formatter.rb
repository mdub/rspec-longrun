require "rspec/core/formatters/base_text_formatter"

module RSpec
  module Longrun

    class Formatter < RSpec::Core::Formatters::BaseTextFormatter

      def initialize(output)
        super(output)
        @blocks = [Block.new(true)]
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
        begin_block(detail_color(example.description))
      end

      def example_passed(example)
        super(example)
        end_block(success_color("OK"))
      end

      def example_pending(example)
        super(example)
        end_block(pending_color("PENDING: " + example.execution_result[:pending_message]))
      end

      def example_failed(example)
        super(example)
        end_block(failure_color("FAILED"))
      end

      def step_started(description)
        begin_block(description)
      end

      def step_finished(description)
        end_block
      end

      private

      def current_block
        @blocks.last
      end

      def begin_block(message)
        unless current_block.nested?
          output << faint("{\n")
          current_block.nested!
        end
        output << current_indentation
        output << message.strip
        output << ' '
        @blocks.push(Block.new)
      end

      def end_block(message = nil)
        block = @blocks.pop
        block.finished!
        if block.nested?
          output << current_indentation
          output << faint('} ')
        end
        if message
          output << message.strip
          output << ' '
        end
        output << faint('(' + block.timing + ')')
        output << "\n"
      end

      def current_indentation
        '  ' * (@blocks.size - 1)
      end

      def faint(text)
        color(text, "\e[2m")
      end

      class Block

        def initialize(nested = false)
          @began_at = Time.now
          @nested = nested
        end

        def finished!
          @finished_at = Time.now
        end

        def timing
          delta = @finished_at - @began_at
          '%.2fs' % delta
        end

        def nested!
          @nested = true
        end

        def nested?
          @nested
        end

      end

    end

  end
end
