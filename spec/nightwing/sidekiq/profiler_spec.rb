require "spec_helper"

describe Nightwing::Sidekiq::Profiler do
  subject { Nightwing::Sidekiq::Profiler.new(client: Nightwing::DebugClient.new) }

  let(:time_in_ms) { 55 }
  let(:buffer) { 5 }

  describe "#call" do
    it "records time" do
      expect(subject.client).to receive(:timing) do |*args|
        expect(args.first).to eq("sidekiq.default.my_worker.time")
        expect(args.last).to be_between(0, time_in_ms + buffer)
      end

      expect(subject.client).to receive(:timing) do |*args|
        expect(args.first).to eq("sidekiq.default.time")
        expect(args.last).to be_between(0, time_in_ms + buffer)
      end

      subject.call(MyWorker.new, nil, "default") do
        sleep time_in_ms / 1_000 # sleep for ~55ms
      end
    end

    it "records memory" do
      expect(subject.client).to receive(:measure).with("sidekiq.default.my_worker.memory.delta", 0).and_call_original
      expect(subject.client).to receive(:measure).with("sidekiq.default.my_worker.gc.count", 0).and_call_original
      expect(subject.client).to receive(:measure).with("sidekiq.default.memory.delta", 0).and_call_original
      expect(subject.client).to receive(:measure).with("sidekiq.default.gc.count", 0).and_call_original

      subject.call(MyWorker.new, nil, "default") do
        # beep
      end
    end
  end
end
