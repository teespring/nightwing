require 'librato-rack'

module Robin
  module Sidekiq
    class QueueStats
      attr_reader :namespace

      def initialize(options = {})
        @namespace = options.fetch(:namespace, 'robin.sidekiq')

        capture_snapshot!
      end

      def call(worker, msg, queue)
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
