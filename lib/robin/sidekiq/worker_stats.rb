require "librato-rack"

module Robin
  module Sidekiq
    class WorkerStats < Base
      def call(worker_class, job, queue, redis_pool)
        exception = nil
        worker_namespace = metrics.for(queue: queue, worker: worker_class)

        Librato.increment "#{worker_namespace}.processed"

        begin
          yield
        rescue => e
          exception = e
        end

        if exception
          Librato.increment "#{worker_namespace}.failed"
        end
      end
    end
  end
end
