module RSpec
  module Longrun
    module DSL

      def step(description)
        # pending(description) unless block_given?
        # begin
        #   @_rspec_reporter.step_started(description)
        #   yield
        # ensure
        #   @_rspec_reporter.step_finished(description)
        # end
      end

    end
  end
end
