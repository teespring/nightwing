require "spec_helper"

class Redis
  class Client
    def call(*_)
      @performed = true
    end

    def called?
      @performed
    end
  end
end

describe "Redis extensions" do
  subject { Redis::Client.new }

  before do
    require "nightwing/extensions/redis"
  end

  describe "#peform" do
    it "measures time" do
      expect(Nightwing.client).to receive(:timing) do |*args|
        expect(args.first).to eq("redis.command.time")
        expect(args.last > 0).to be(true)
      end

      expect(Nightwing.client).to receive(:timing) do |*args|
        expect(args.first).to eq("redis.command.foo.time")
        expect(args.last > 0).to be(true)
      end

      expect(Nightwing.client).to receive(:increment).with("redis.command.processed")
      expect(Nightwing.client).to receive(:increment).with("redis.command.foo.processed")

      subject.call :foo
    end

    it "actually calls perform" do
      subject.call :foo
      expect(subject).to be_called
    end
  end
end
