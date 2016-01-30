require "rspec"
require "robin/sidekiq/stats"

describe Robin::Sidekiq::Stats do
  subject { Robin::Sidekiq::Stats.new }

  before do
    fake_set = Struct.new(:size).new(1)
    allow(Sidekiq::RetrySet).to receive(:new).and_return(fake_set)
    allow(Sidekiq::ScheduledSet).to receive(:new).and_return(fake_set)
  end

  describe "#call" do
    context "when everything just works" do
      it "increments process count" do
        expect(Librato).to receive(:measure).with("robin.sidekiq.retries", 1)
        expect(Librato).to receive(:measure).with("robin.sidekiq.scheduled", 1)
        expect(Librato).to receive(:increment).with("robin.sidekiq.processed")

        subject.call(nil, nil, nil) do
          # beep
        end
      end
    end

    context "when something fails" do
      it "increments process and failure count" do
        expect(Librato).to receive(:measure).with("robin.sidekiq.retries", 1)
        expect(Librato).to receive(:measure).with("robin.sidekiq.scheduled", 1)
        expect(Librato).to receive(:increment).with("robin.sidekiq.processed")
        expect(Librato).to receive(:increment).with("robin.sidekiq.failed")

        expect do
          subject.call(nil, nil, nil) do
            fail "beep"
          end
        end.to raise_error RuntimeError
      end
    end
  end
end