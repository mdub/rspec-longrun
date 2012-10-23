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

  before do
    formatter.stub(:color_enabled?).and_return(false)
    example_group.run(formatter)
  end

  context "for nested example groups" do

    let(:example_group) do
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

end
