require "robin/sidekiq/base"

module Robin
  module Sidekiq
    class WorkerStats < Base
      def call(worker_class, _job, queue, _redis_pool)
        exception = nil
        worker_namespace = metrics.for(queue: queue, worker: worker_class)

        client.increment "#{worker_namespace}.processed"

        begin
          yield
        rescue => e
          exception = e
        end

        if exception
          client.increment "#{worker_namespace}.failed"
          raise exception
        end

        client.increment "#{worker_namespace}.finished"
      end
    end
  end
end
