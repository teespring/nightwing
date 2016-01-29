require "librato-rack"

module Robin
  module Sidekiq
    ##
    # Sidekiq server middleware for measuring Sidekiq stats
    class QueueStats < Base
      ##
      # Sends Sidekiq metrics to Librato then yields
      #
      # @param [Sidekiq::Worker] worker
      #   The worker the job belongs to.
      #
      # @param [Hash] _msg
      #   The job message.
      #
      # @param [String] queue
      #   The current queue.
      def call(worker, _msg, queue)
        Librato.measure "#{namespace}.retries", retries.size
        Librato.measure "#{namespace}.scheduled", scheduled.size
        Librato.increment "#{namespace}.processed"

        # queue specific
        sidekiq_queue = ::Sidekiq::Queue.new(queue)
        queue_namespace = metrics.for(queue: queue)
        Librato.measure "#{queue_namespace}.size", sidekiq_queue.size
        Librato.measure "#{queue_namespace}.latency", sidekiq_queue.latency
        Librato.increment "#{queue_namespace}.processed"

        yield if block_given?
      rescue => e
        Librato.increment "#{namespace}.failed"
        Librato.increment "#{queue_namespace}.failed"
        raise e
      end

      private

      def retries
        @_retries ||= ::Sidekiq::RetrySet.new
      end

      def scheduled
        @_scheduled ||= ::Sidekiq::ScheduledSet.new
      end
    end
  end
end
