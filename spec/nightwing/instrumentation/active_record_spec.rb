require "spec_helper"
require "active_support/all"

describe Nightwing::Instrumentation::ActiveRecord do
  subject { described_class.new }

  describe "#call" do
    context "when given select SQL query" do
      it "measures time" do
        expect(Nightwing.client).to receive(:timing).with("sql.select.time", 2_000)
        expect(Nightwing.client).to receive(:timing).with("sql.select.users.time", 2_000)
        expect(Nightwing.client).to receive(:increment).with("sql.select.processed")
        expect(Nightwing.client).to receive(:increment).with("sql.select.users.processed")

        payload = { name: "SQL", sql: "select * from users;" }
        subject.call(nil, 5.seconds.ago, 3.seconds.ago, nil, payload)
      end
    end

    context "when given insert SQL query" do
      it "measures time" do
        expect(Nightwing.client).to receive(:timing).with("sql.insert.time", 1_000)
        expect(Nightwing.client).to receive(:timing).with("sql.insert.foo.time", 1_000)
        expect(Nightwing.client).to receive(:increment).with("sql.insert.processed")
        expect(Nightwing.client).to receive(:increment).with("sql.insert.foo.processed")

        payload = { name: "SQL", sql: "insert into foo values(1, 2, 3);" }
        subject.call(nil, 10.seconds.ago, 9.seconds.ago, nil, payload)
      end
    end
  end
end
