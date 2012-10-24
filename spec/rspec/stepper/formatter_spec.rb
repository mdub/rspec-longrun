require "rspec/stepper"
require "stringio"

describe RSpec::Stepper::Formatter do

  let(:output_buffer) { StringIO.new }
  let(:formatter) { described_class.new(output_buffer) }

  def undent(raw)
    if raw =~ /\A( +)/
      indent = $1
      raw.gsub(/^#{indent}/, '').gsub(/ +$/, '')
    else
      raw
    end
  end

  def output
    output_buffer.string
  end

  module NoColor

    def color_enabled?
      false
    end

  end

  before do
    formatter.extend(NoColor)
    suite.run(formatter)
  end

  context "for nested example groups" do

    let(:suite) do
      RSpec::Core::ExampleGroup.describe("foo") do
        describe "bar" do
          describe "baz" do
          end
        end
        describe "qux" do
        end
      end
    end

    it "outputs nested group name" do
      output.should eql(undent(<<-EOF))
        foo
          bar
            baz
          qux
      EOF
    end

  end

  context "with examples" do

    let(:suite) do
      RSpec::Core::ExampleGroup.describe("suite") do
        it "works" do; end
        it "is unimplemented" do
          pending "implement me"
        end
        it "fails" do
          fail "no worky"
        end
      end
    end

    it "outputs example names and status" do
      output.should eql(undent(<<-EOF))
        suite
          works
            PASSED
          is unimplemented
            PENDING (implement me)
          fails
            FAILED
      EOF
    end

  end

  context "with steps" do

    let(:suite) do
      RSpec::Core::ExampleGroup.describe("suite") do
        it "has steps" do
          step "Collect underpants" do
          end
          step "Er ..." do
            step "(thinking)" do
            end
          end
          step "Profit!" do
          end
        end
      end
    end

    it "outputs steps" do
      step "try steps" do
        output.should eql(undent(<<-EOF))
          suite
            has steps
              - Collect underpants
              - Er ...
                - (thinking)
              - Profit!
              PASSED
        EOF
      end
    end

  end

end
