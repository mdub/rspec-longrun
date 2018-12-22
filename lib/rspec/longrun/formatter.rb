require "rspec/core/formatters/base_text_formatter"

module RSpec
  module Longrun

    class Formatter < RSpec::Core::Formatters::BaseTextFormatter

      RSpec::Core::Formatters.register self,
        :start,
        :example_group_started, :example_group_finished,
        :example_started, :example_passed,
        :example_pending, :example_failed

      def initialize(output)
        super(output)
        @blocks = [Block.new(true)]
      end

      def start(notification)
        Thread.current["rspec.longrun.formatter"] = self
      end

      def example_group_started(notification)
        begin_block(notification.group.description)
      end

      def example_group_finished(notification)
        end_block
      end

      def example_started(notification)
        begin_block(wrap(notification.example.description, :detail))
      end

      def example_passed(notification)
        end_block(wrap("OK", :success))
      end

      def example_pending(notification)
        end_block(wrap("PENDING: " + notification.example.execution_result.pending_message, :pending))
      end

      def example_failed(notification)
        end_block(wrap("FAILED", :failure))
      end

      def step_started(description)
        begin_block(description)
      end

      def step_finished
        end_block(wrap("✓", :success))
      end

      def step_failed
        end_block(wrap("✗", :failure))
      end

      def step_pending
        end_block(wrap("PENDING", :pending))
      end

      private

      def wrap(*args)
        RSpec::Core::Formatters::ConsoleCodes.wrap(*args)
      end

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
        return text unless RSpec.configuration.color_enabled?
        "\e[2m#{text}\e[0m"
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
