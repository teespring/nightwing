require "spec_helper"
require "active_support/all"

describe Nightwing::Instrumentation::ActiveRecord do
  subject { described_class.new(namespace: "instr") }

  describe "#call" do
    context "when given select SQL query" do
      it "measures time" do
        expect(subject.client).to receive(:timing).with("instr.sql.users.select.time", 2_000)
        payload = { name: "SQL", sql: "select * from users;" }
        subject.call(nil, 5.seconds.ago, 3.seconds.ago, nil, payload)
      end
    end

    context "when given insert SQL query" do
      it "measures time" do
        expect(subject.client).to receive(:timing).with("instr.sql.foo.insert.time", 1_000)
        payload = { name: "SQL", sql: "insert into foo values(1, 2, 3);" }
        subject.call(nil, 10.seconds.ago, 9.seconds.ago, nil, payload)
      end
    end
  end
end
