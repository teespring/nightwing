module Robin
  module Sidekiq
    ##
    # Sidekiq server middleware for measuring Sidekiq queues
    class QueueStats < Base
      ##
      # Sends Sidekiq queue metrics to Librato then yields
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
        exception = nil
        sidekiq_queue = ::Sidekiq::Queue.new(queue)
        queue_namespace = metrics.for(queue: queue)

        Librato.measure "#{queue_namespace}.size", sidekiq_queue.size
        Librato.measure "#{queue_namespace}.latency", sidekiq_queue.latency
        Librato.increment "#{queue_namespace}.processed"

        begin
          yield
        rescue => e
          exception = e
        end

        if exception
          Librato.increment "#{queue_namespace}.failed"
          raise exception
        end
      end
    end
  end
end
