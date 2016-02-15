require "spec_helper"

class Dalli
  class Client
    def perform(*_)
      @performed = true
    end

    def called?
      @performed
    end
  end
end

describe "Dalli extensions" do
  subject { Dalli::Client.new }

  before do
    require "nightwing/extensions/dalli"
  end

  describe "#peform" do
    it "measures time" do
      expect(Nightwing.client).to receive(:timing) do |*args|
        expect(args.first).to eq("memcache.command.time")
        expect(args.last > 0).to be(true)
      end

      expect(Nightwing.client).to receive(:timing) do |*args|
        expect(args.first).to eq("memcache.command.foo.time")
        expect(args.last > 0).to be(true)
      end

      expect(Nightwing.client).to receive(:increment).with("memcache.command.processed")
      expect(Nightwing.client).to receive(:increment).with("memcache.command.foo.processed")

      subject.perform :foo
    end

    it "actually calls perform" do
      subject.perform :foo
      expect(subject).to be_called
    end
  end
end
