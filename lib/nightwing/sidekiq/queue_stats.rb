require "nightwing/sidekiq/base"

module Nightwing
  module Sidekiq
    ##
    # Sidekiq server middleware for measuring Sidekiq queues
    class QueueStats < Base
      ##
      # Sends Sidekiq queue metrics to client then yields
      #
      # @param [Sidekiq::Worker] _worker
      #   The worker the job belongs to.
      #
      # @param [Hash] _msg
      #   The job message.
      #
      # @param [String] queue
      #   The current queue.
      def call(_worker, _msg, queue)
        sidekiq_queue = ::Sidekiq::Queue.new(queue)
        queue_namespace = metrics.for(queue: queue)

        unless disabled_metrics.include? :queue_depth
          QueueMonitoring.new(metrics_collector: client, namespace: namespace)
                         .report_depth_metrics_for_queues([sidekiq_queue])
        end

        client.increment "#{queue_namespace}.processed"

        begin
          yield
        rescue
          client.increment "#{queue_namespace}.failed"
          raise
        end
      end
    end
  end
end
