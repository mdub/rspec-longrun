require "rspec/longrun"
require "stringio"

describe RSpec::Longrun::Formatter do

  let(:output_buffer) { StringIO.new }
  let(:formatter) { described_class.new(output_buffer) }
  let(:reporter) { RSpec::Core::Reporter.new(formatter) }

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

  def normalized_output
    output.gsub(/0\.\d\ds/, "N.NNs")
  end

  module NoColor

    def color_enabled?
      false
    end

  end

  before do
    formatter.extend(NoColor)
    suite.run(reporter)
  end

  context "for nested example groups" do

    let(:suite) do
      RSpec::Core::ExampleGroup.describe("foo") do
        describe "bar" do
          describe "baz" do
            it "bleeds"
          end
        end
        describe "qux" do
          it "hurts"
        end
      end
    end

    it "outputs nested group names" do
      normalized_output.should eql(undent(<<-EOF))
        foo {
          bar {
            baz {
              bleeds PENDING: Not yet implemented (N.NNs)
            } (N.NNs)
          } (N.NNs)
          qux {
            hurts PENDING: Not yet implemented (N.NNs)
          } (N.NNs)
        } (N.NNs)
      EOF
    end

  end

  context "with examples" do

    let(:suite) do
      RSpec::Core::ExampleGroup.describe("suite") do
        example "works" do; end
        example "is unimplemented" do
          pending "implement me"
        end
        example "fails" do
          fail "no worky"
        end
      end
    end

    it "outputs example names and status" do
      normalized_output.should eql(undent(<<-EOF))
        suite {
          works OK (N.NNs)
          is unimplemented PENDING: implement me (N.NNs)
          fails FAILED (N.NNs)
        } (N.NNs)
      EOF
    end

  end

  context "with steps" do

    let(:suite) do
      RSpec::Core::ExampleGroup.describe("suite") do
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
    end

    it "outputs steps" do
      normalized_output.should eql(undent(<<-EOF))
        suite {
          has steps {
            Collect underpants (N.NNs)
            Er ... {
              (thinking) (N.NNs)
            } (N.NNs)
          } PENDING: Profit! (N.NNs)
        } (N.NNs)
      EOF
    end

  end

end
