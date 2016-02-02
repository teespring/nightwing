require "spec_helper"

describe Robin::Metric do
  subject { described_class.new("sidekiq") }

  it "returns name for queue metric" do
    metric_name = subject.for(queue: "default")
    expect(metric_name).to eq("sidekiq.default")
  end

  it "returns name for worker metric" do
    metric_name = subject.for(queue: "default", worker: "CoolWorker")
    expect(metric_name).to eq("sidekiq.default.cool_worker")
  end

  it "returns name for module worker metric" do
    metric_name = subject.for(queue: "default", worker: "App::AwesomeWorker")
    expect(metric_name).to eq("sidekiq.default.app_awesome_worker")
  end
end
