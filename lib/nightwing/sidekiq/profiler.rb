require "nightwing/sidekiq/profiler"

module Nightwing
  module Sidekiq
    class Profiler < Base
      def call(worker, _msg, queue)
        queue_namespace = metrics.for(queue: queue)
        worker_namespace = metrics.for(queue: queue, worker: worker)

        begin
          started_at = Time.now
          yield
        ensure
          time_spent_in_worker = ((Time.now - started_at) * 1_000).round
          client.timing "#{queue_namespace}.time", time_spent_in_worker
          client.timing "#{worker_namespace}.time", time_spent_in_worker
        end
      end
    end
  end
end
