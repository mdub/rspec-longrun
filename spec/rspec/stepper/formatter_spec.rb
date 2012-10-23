require "rspec/stepper/formatter"
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

  context "with a passing examples" do

    let(:suite) do
      RSpec::Core::ExampleGroup.describe("suite") do
        it "good" do; end
        it "great" do; end
      end
    end

    it "declares success" do
      output.should eql(undent(<<-EOF))
        suite
          good
          * PASSED
          great
          * PASSED
      EOF
    end

  end

end
