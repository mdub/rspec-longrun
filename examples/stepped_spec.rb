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
    step "Profit!" do
      pending "a real plan"
      fail
    end
  end

  example "deep fail" do
    step "Level 1" do
      step "Level 2" do
        step "Level 3" do
          expect(1+1).to eq(3)
        end
      end
    end
  end

end
