require 'rspec'
require 'rspec/longrun'

RSpec.describe("stepped") do

  include RSpec::Longrun::DSL
  example "has steps" do
    step "Collect underpants" do
    end
    step "Er ..." do
      step "(thinking)" do
      end
    end
    step "Profit!"
  end

end
