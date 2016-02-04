require "spec_helper"

describe Nightwing::Sidekiq::Profiler do
  subject { Nightwing::Sidekiq::Profiler.new(client: Nightwing::NilClient.new) }

  let(:time_in_ms) { 55 }
  let(:buffer) { 5 }

  describe "#call" do
    it "records time" do
      expect(subject.client).to receive(:timing) do |*args|
        expect(args.first).to eq("sidekiq.default.foo.time")
        expect(args.last).to be_between(0, time_in_ms + buffer)
      end

      expect(subject.client).to receive(:timing) do |*args|
        expect(args.first).to eq("sidekiq.default.time")
        expect(args.last).to be_between(0, time_in_ms + buffer)
      end

      subject.call("foo", nil, "default") do
        sleep time_in_ms / 1_000 # sleep for ~55ms
      end
    end

    it "records memory" do
      expect(subject.client).to receive(:measure).with("sidekiq.default.foo.memory_used", 0)
      expect(subject.client).to receive(:measure).with("sidekiq.default.foo.gc.count", 0)
      expect(subject.client).to receive(:measure).with("sidekiq.default.memory_used", 0)
      expect(subject.client).to receive(:measure).with("sidekiq.default.gc.count", 0)

      subject.call("foo", nil, "default") do
        # beep
      end
    end
  end
end
