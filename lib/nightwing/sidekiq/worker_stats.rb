require "nightwing/sidekiq/base"

module Nightwing
  module Sidekiq
    class WorkerStats < Base
      def call(worker, msg, queue)
        worker_namespace = metrics.for(queue: queue, worker: worker.class)

        client.increment "#{worker_namespace}.processed"

        if msg["retry"]
          if msg["retry_count"].to_i > 0
            client.increment "#{worker_namespace}.retried"
          end
        end

        begin
          yield
        rescue
          client.increment "#{worker_namespace}.failed"
          raise
        end

        client.increment "#{worker_namespace}.finished"
      end
    end
  end
end
