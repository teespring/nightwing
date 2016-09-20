module Nightwing
  module Sidekiq
    class QueueMonitoring
      attr_reader :metrics_collector, :namespace

      def initialize(metrics_collector:, namespace: "sidekiq")
        @metrics_collector = metrics_collector
        @namespace = namespace
      end

      def report_depth_metrics_for_queues(queues)
        queues.each do |queue|
          metrics_collector.measure queue_metric_name(queue, "size"), queue.size
          metrics_collector.measure queue_metric_name(queue, "latency"), queue.latency
        end
      end

      protected

      def queue_metric_name(queue, metric_name)
        "#{namespace}.#{queue.name}.#{metric_name}"
      end
    end
  end
end
