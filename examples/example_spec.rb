require 'rspec'
require 'rspec/longrun'

describe "Underpants gnomes" do

  include RSpec::Longrun::DSL

  it "The plan" do
    step "Collect underpants" do
    end
    step "Umm ..." do
      sleep 1.2 # thinking
    end
    step "Profit!"
  end

end

describe "Killer app" do

  include RSpec::Longrun::DSL

  describe "Some feature" do

    it "Scenario 1" do
      step "Step 1" do
      end
      step "Step 2" do
      end
      step "Step 3" do
      end
    end

    it "Scenario 2" do
    end

  end

  describe "Another feature" do

    it "Scenario" do
      step "Step 1" do
      end
      step "Step 2" do
      end
    end

  end

end
