require "nightwing/sidekiq/base"

module Nightwing
  module Sidekiq
    class WorkerStats < Base
      def call(worker, _msg, queue)
        worker_namespace = metrics.for(queue: queue, worker: worker.class)

        client.increment "#{worker_namespace}.processed"

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
