require "rspec/longrun"
require "stringio"

describe RSpec::Longrun::Formatter do

  let(:output_buffer) { StringIO.new }

  def output
    output_buffer.string
  end

  def normalized_output
    output.gsub(/0\.\d\ds/, "N.NNs")
  end

  let(:formatter) { described_class.new(output_buffer) }

  before do
    allow(RSpec.configuration).to receive(:color_enabled?).and_return(false)
  end

  def example_group(desc)
    notification = double(group: double(description: desc))
    formatter.example_group_started(notification)
    yield if block_given?
    formatter.example_group_finished(notification)
  end

  def example(desc, result, pending_message = nil)
    notification = double(
      example: double(
        description: desc,
        execution_result: double(pending_message: pending_message)
      )
    )
    formatter.example_started(notification)
    yield if block_given?
    formatter.public_send("example_#{result}", notification)
  end

  def step(desc)
    formatter.step_started(desc)
    yield if block_given?
    formatter.step_finished
  end

  context "given an empty example group" do

    before do
      example_group "suite" do
      end
    end

    it "outputs suite entry" do
      expect(normalized_output).to eql(<<~EOF)
        suite (N.NNs)
      EOF
    end

  end

  context "with examples" do

    before do
      example_group "suite" do
        example "works", :passed
        example "fails", :failed
        example "is unimplemented", :pending, "implement me"
      end
    end

    it "outputs example names and status" do
      expect(normalized_output).to eql(<<~EOF)
        suite {
          works OK (N.NNs)
          fails FAILED (N.NNs)
          is unimplemented PENDING: implement me (N.NNs)
        } (N.NNs)
      EOF
    end

  end

  context "with nested example groups" do

    before do
      example_group "top" do
        example_group "A" do
        end
        example_group "B" do
          example_group "1" do
          end
        end
      end
    end

    it "outputs nested group names" do
      expect(normalized_output).to eql(<<~EOF)
        top {
          A (N.NNs)
          B {
            1 (N.NNs)
          } (N.NNs)
        } (N.NNs)
      EOF
    end

  end

  context "with steps" do

    before do
      example_group "suite" do
        example "has steps", :passed do
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
      expect(normalized_output).to eql(<<~EOF)
        suite {
          has steps {
            Collect underpants ✓ (N.NNs)
            Er ... {
              (thinking) ✓ (N.NNs)
            } ✓ (N.NNs)
            Profit! ✓ (N.NNs)
          } OK (N.NNs)
        } (N.NNs)
      EOF
    end

  end

end
