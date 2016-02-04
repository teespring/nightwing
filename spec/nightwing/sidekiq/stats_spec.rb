require "spec_helper"

describe Nightwing::Sidekiq::Stats do
  subject { Nightwing::Sidekiq::Stats.new(client: Nightwing::DebugClient.new) }

  before do
    fake_set = Struct.new(:size).new(1)
    allow(Sidekiq::RetrySet).to receive(:new).and_return(fake_set)
    allow(Sidekiq::ScheduledSet).to receive(:new).and_return(fake_set)
  end

  describe "#call" do
    context "when everything just works" do
      it "increments process count" do
        expect(subject.client).to receive(:measure).with("sidekiq.retries", 1)
        expect(subject.client).to receive(:measure).with("sidekiq.scheduled", 1)
        expect(subject.client).to receive(:increment).with("sidekiq.processed")

        subject.call(nil, nil, nil) do
          # beep
        end
      end
    end

    context "when something fails" do
      it "increments process and failure count" do
        expect(subject.client).to receive(:measure).with("sidekiq.retries", 1)
        expect(subject.client).to receive(:measure).with("sidekiq.scheduled", 1)
        expect(subject.client).to receive(:increment).with("sidekiq.processed")
        expect(subject.client).to receive(:increment).with("sidekiq.failed")

        expect do
          subject.call(nil, nil, nil) do
            fail "beep"
          end
        end.to raise_error RuntimeError
      end
    end
  end
end
