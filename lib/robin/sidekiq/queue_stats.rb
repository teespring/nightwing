require "librato-rack"

module Robin
  module Sidekiq
    ##
    # Sidekiq server middleware for measuring Sidekiq stats
    class QueueStats
      attr_reader :namespace

      def initialize(options = {})
        @namespace = options.fetch(:namespace, "robin.sidekiq")
      end

      ##
      # Sends Sidekiq metrics to Librato then yields
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
        Librato.measure "#{namespace}.retries", retries.size
        Librato.measure "#{namespace}.scheduled", scheduled.size
        Librato.increment "#{namespace}.processed"

        # queue specific
        sidekiq_queue = ::Sidekiq::Queue.new(queue)
        Librato.measure "#{namespace}.#{queue}.size", sidekiq_queue.size
        Librato.measure "#{namespace}.#{queue}.latency", sidekiq_queue.latency
        Librato.increment "#{namespace}.#{queue}.processed"

        yield if block_given?
      rescue e
        Librato.increment "#{namespace}.failed"
        Librato.increment "#{namespace}.#{queue}failed"
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
