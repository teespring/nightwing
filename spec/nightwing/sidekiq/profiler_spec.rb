require "spec_helper"

describe Nightwing::Sidekiq::Profiler do
  subject { Nightwing::Sidekiq::Profiler.new(client: Nightwing::NilClient.new) }

  let(:time_in_ms) { 55 }
  let(:buffer) { 5 }

  describe "#call" do
    it "profiles the worker" do
      expect(subject.client).to receive(:timing) do |*args|
        expect(args.first).to eq("sidekiq.default.foo.time")
        expect(args.last).to be_between(0, time_in_ms + buffer)
      end

      subject.call("foo", nil, "default") do
        sleep time_in_ms / 1_000 # sleep for ~55ms
      end
    end
  end
end
