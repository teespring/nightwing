require 'librato-rack'

module Robin
  module Sidekiq
    class QueueStats
      attr_reader :namespace, :previous_stats

      def initialize(options = {})
        @namespace = options.fetch(:namespace, 'robin.sidekiq')

        capture_snapshot!
      end

      def call(worker, msg, queue)
        begin
          Librato.measure "#{namespace}.retries", retries.size
          Librato.measure "#{namespace}.scheduled", scheduled.size
          Librato.measure "#{namespace}.enqueued", (stats.enqueued - previous_stats[:enqueued])
          Librato.measure "#{namespace}.processed", (stats.processed - previous_stats[:processed])
          Librato.measure "#{namespace}.failed", (stats.failed - previous_stats[:failed])

          # queue specific
          sidekiq_queue = ::Sidekiq::Queue.new(queue)
          Librato.measure "#{namespace}.#{queue}.size", sidekiq_queue.size
          Librato.measure "#{namespace}.#{queue}.latency", sidekiq_queue.latency

          capture_snapshot!

          Librato.increment "robin.sidekiq.measured"
        rescue
          Librato.increment "robin.failed"
        end

        yield if block_given?
      end

      private

      def capture_snapshot!
        previous_stats[:enqueued] = stats.enqueued
        previous_stats[:processed] = stats.processed
        previous_stats[:failed] = stats.failed
        previous_stats[:retry_scheduled] = stats.failed
      end

      def retries
        @_retries ||= ::Sidekiq::RetrySet.new
      end

      def stats
        @_stats ||= ::Sidekiq::Stats.new
      end

      def scheduled
        @_scheduled ||= ::Sidekiq::ScheduledSet.new
      end
    end
  end
end
