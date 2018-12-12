module RSpec
  module Longrun
    module DSL

      def step(description)
        rspec_longrun_formatter.step_started(description)
        ok = false
        begin
          yield if block_given?
          rspec_longrun_formatter.step_finished
          ok = true
        ensure
          rspec_longrun_formatter.step_failed unless ok
        end
      end

      def xstep(description)
        rspec_longrun_formatter.step_started(description)
        rspec_longrun_formatter.step_pending
      end

      private

      def rspec_longrun_formatter
        Thread.current["rspec.longrun.formatter"] || NullStepFormatter.new
      end

      class NullStepFormatter

        def step_started(_description)
        end

        def step_finished
        end

        def step_failed
        end

      end

    end
  end
end
