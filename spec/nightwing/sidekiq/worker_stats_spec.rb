require "spec_helper"

describe Nightwing::Sidekiq::WorkerStats do
  subject { Nightwing::Sidekiq::WorkerStats.new(client: Nightwing::DebugClient.new) }

  describe "#call" do
    context "when everything just works" do
      it "increments process count" do
        expect(subject.client).to receive(:increment).with("sidekiq.default.my_worker.processed").and_call_original
        expect(subject.client).to receive(:increment).with("sidekiq.default.my_worker.finished").and_call_original

        subject.call(MyWorker.new, {}, "default") do
          # beep
        end
      end
    end

    context "when something fails" do
      it "increments process and failure count" do
        expect(subject.client).to receive(:increment).with("sidekiq.default.my_worker.processed").and_call_original
        expect(subject.client).to receive(:increment).with("sidekiq.default.my_worker.failed").and_call_original

        expect do
          subject.call(MyWorker.new, {}, "default") do
            fail "beep"
          end
        end.to raise_error RuntimeError
      end
    end

    context "when being retried" do
      it "increments process and retried count" do
        expect(subject.client).to receive(:increment).with("sidekiq.default.my_worker.processed").and_call_original
        expect(subject.client).to receive(:increment).with("sidekiq.default.my_worker.retried").and_call_original
        expect(subject.client).to receive(:increment).with("sidekiq.default.my_worker.finished").and_call_original

        subject.call(MyWorker.new, { "retry" => 0, "retry_count" => 2 }, "default") do
          # beep
        end
      end
    end
  end
end
