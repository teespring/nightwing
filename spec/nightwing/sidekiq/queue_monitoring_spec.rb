require "spec_helper"

describe Nightwing::Sidekiq::QueueMonitoring do
  subject(:monitor) { described_class.new(metrics_collector: metrics_collector, namespace: "a_namespace") }

  let(:fake_queue) { instance_double(Sidekiq::Queue, name: "fake_queue", size: 5, latency: 10) }
  let(:another_fake_queue) { instance_double(Sidekiq::Queue, name: "another_fake_queue", size: 3, latency: 4) }
  let(:metrics_collector) { Nightwing::DebugClient.new }

  describe "#report_depth_metrics_for_queues" do
    it "sends queue size and queue latency metrics to the metrics collector for each queue" do
      expect(metrics_collector).to receive(:measure).with("a_namespace.fake_queue.size", 5).and_call_original
      expect(metrics_collector).to receive(:measure).with("a_namespace.fake_queue.latency", 10).and_call_original
      expect(metrics_collector).to receive(:measure).with("a_namespace.another_fake_queue.size", 3).and_call_original
      expect(metrics_collector).to receive(:measure).with("a_namespace.another_fake_queue.latency", 4).and_call_original

      monitor.report_depth_metrics_for_queues([fake_queue, another_fake_queue])
    end
  end
end
