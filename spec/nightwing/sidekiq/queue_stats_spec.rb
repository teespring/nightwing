require "spec_helper"

describe Nightwing::Sidekiq::QueueStats do
  subject { Nightwing::Sidekiq::QueueStats.new(client: Nightwing::DebugClient.new, disabled_metrics: disabled_metrics) }
  let(:disabled_metrics) { [] }

  describe "#call" do
    let(:fake_queue) { instance_double(::Sidekiq::Queue, name: "fake_queue", size: 0, latency: 0) }

    before do
      allow(Sidekiq::Queue).to receive(:new).with(fake_queue.name).and_return fake_queue
    end

    context "when everything just works" do
      it "increments process count" do
        expect(subject.client).to receive(:measure).with("sidekiq.fake_queue.size", 0).and_call_original
        expect(subject.client).to receive(:measure).with("sidekiq.fake_queue.latency", 0).and_call_original
        expect(subject.client).to receive(:increment).with("sidekiq.fake_queue.processed").and_call_original

        subject.call(nil, nil, fake_queue.name) do
          # beep
        end
      end

      context "and queue depth metrics are disabled" do
        let(:disabled_metrics) { [:queue_depth] }

        it "does not report them" do
          expect(subject.client).not_to receive(:measure).with("sidekiq.fake_queue.size", any_args)
          expect(subject.client).not_to receive(:measure).with("sidekiq.fake_queue.latency", any_args)

          subject.call(nil, nil, fake_queue.name) do
            # beep
          end
        end
      end
    end

    context "when something fails" do
      it "increments process and failure count" do
        expect(subject.client).to receive(:measure).with("sidekiq.fake_queue.size", 0).and_call_original
        expect(subject.client).to receive(:measure).with("sidekiq.fake_queue.latency", 0).and_call_original
        expect(subject.client).to receive(:increment).with("sidekiq.fake_queue.processed").and_call_original
        expect(subject.client).to receive(:increment).with("sidekiq.fake_queue.failed").and_call_original

        expect do
          subject.call(nil, nil, fake_queue.name) do
            fail "beep"
          end
        end.to raise_error RuntimeError
      end

      context "and queue depth metrics are disabled" do
        let(:disabled_metrics) { [:queue_depth] }

        it "does not report them" do
          expect(subject.client).not_to receive(:measure).with("sidekiq.fake_queue.size", any_args)
          expect(subject.client).not_to receive(:measure).with("sidekiq.fake_queue.latency", any_args)

          expect do
            subject.call(nil, nil, fake_queue.name) do
              fail "beep"
            end
          end.to raise_error RuntimeError
        end
      end
    end
  end
end
