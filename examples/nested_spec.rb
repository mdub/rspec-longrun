require 'rspec'
require 'rspec/longrun'

RSpec.describe("foo") do
  describe "bar" do
    describe "baz" do
      it "bleeds"
    end
  end
  describe "qux" do
    it "hurts"
  end
end
