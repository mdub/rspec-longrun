module RSpec
  module Longrun
    module DSL

      def step(description)
        rspec_longrun_formatter.step_started(description)
        begin
          yield if block_given?
          rspec_longrun_formatter.step_finished
        rescue => e
          rspec_longrun_formatter.step_errored(e)
          raise e
        end
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

        def step_errored(_e)
        end

      end

    end
  end
end
