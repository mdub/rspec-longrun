require 'rspec/longrun/core_ext'

# extend rspec-core with support for "steps"

module RSpec
  module Longrun
    module DSL

      private

      def step(description)
        pending(description) unless block_given?
        begin
          @_rspec_reporter.step_started(description)
          yield
        ensure
          @_rspec_reporter.step_finished(description)
        end
      end

    end
  end
end
