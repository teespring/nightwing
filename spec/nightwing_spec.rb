require "spec_helper"

describe Nightwing do
  describe "#client" do
    context "when client is not set" do
      class MyClient; end

      before do
        Nightwing.client = MyClient.new
      end

      it "returns client" do
        expect(Nightwing.client.class).to eq(MyClient)
      end
    end

    context "when client is not set" do
      before do
        Nightwing.client = nil
      end

      it "returns default client" do
        expect(Nightwing.client.class).to eq(Nightwing::DebugClient)
      end
    end
  end
end
