module Robin
  module Sidekiq
    ##
    # Sidekiq server middleware for measuring Sidekiq stats
    class Stats < Base
      ##
      # Sends Sidekiq metrics to statsd client then yields
      #
      # @param [Sidekiq::Worker] _worker
      #   The worker the job belongs to.
      #
      # @param [Hash] _msg
      #   The job message.
      #
      # @param [String] _queue
      #   The current queue.
      def call(_worker, _msg, _queue)
        exception = nil

        client.measure "#{namespace}.retries", retries.size
        client.measure "#{namespace}.scheduled", scheduled.size
        client.increment "#{namespace}.processed"

        begin
          yield
        rescue => e
          exception = e
        end

        if exception
          client.increment "#{namespace}.failed"
          raise exception
        end
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
