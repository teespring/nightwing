require "rspec"
require "robin/sidekiq/worker_stats"

describe Robin::Sidekiq::WorkerStats do
  subject { Robin::Sidekiq::WorkerStats.new }

  describe "#call" do
    context "when everything just works" do
      it "increments process count" do
        expect(Librato).to receive(:increment).with("robin.sidekiq.default.my_worker.processed")
        expect(Librato).to receive(:increment).with("robin.sidekiq.default.my_worker.finished")

        subject.call("MyWorker", nil, "default", nil) do
          # beep
        end
      end
    end

    context "when something fails" do
      it "increments process and failure count" do
        expect(Librato).to receive(:increment).with("robin.sidekiq.default.my_worker.processed")
        expect(Librato).to receive(:increment).with("robin.sidekiq.default.my_worker.failed")

        expect do
          subject.call("MyWorker", nil, "default", nil) do
            fail "beep"
          end
        end.to raise_error RuntimeError
      end
    end
  end
end
