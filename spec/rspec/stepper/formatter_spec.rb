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

  context "for a simple spec" do

    let(:example_group) do
      RSpec::Core::ExampleGroup.describe("group name") do
      end
    end

    it "outputs group names" do
      output.should == undent(<<-EOF)
        group name
      EOF
    end

  end

end
