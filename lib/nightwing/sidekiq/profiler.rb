require "nightwing/sidekiq/profiler"

module Nightwing
  module Sidekiq
    class Profiler < Base
      def call(worker, _msg, queue)
        namespace = metrics.for(queue: queue, worker: worker)

        begin
          started_at = Time.now
          yield
        ensure
          time_spent_in_worker = (Time.now - started_at) * 1_000
          client.timing "#{namespace}.time", time_spent_in_worker.round
        end
      end
    end
  end
end
