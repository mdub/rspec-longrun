require 'rspec'
require 'rspec/longrun'

RSpec.describe("suite") do
  example "works" do; end
  example "is unimplemented" do
    pending "implement me"
    raise "not implemented"
  end
  example "fails" do
    fail "no worky"
  end
end
