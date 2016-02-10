require "oink"

module Nightwing
  module Sidekiq
    class Profiler < Base
      def call(worker, _msg, queue)
        queue_namespace = metrics.for(queue: queue)
        worker_namespace = metrics.for(queue: queue, worker: worker.class)

        begin
          started_at = Time.now
          initial_gc_count = ::GC.count
          initial_snapshot = memory_snapshot

          yield
        ensure
          finish_snapshot = memory_snapshot
          memory_delta_in_bytes = finish_snapshot - initial_snapshot
          total_time = ((Time.now - started_at) * 1_000).round
          total_gc_count = ::GC.count - initial_gc_count

          client.timing "#{worker_namespace}.time", total_time
          client.measure "#{worker_namespace}.memory.delta", memory_delta_in_bytes
          client.measure "#{worker_namespace}.gc.count", total_gc_count

          client.timing "#{queue_namespace}.time", total_time
          client.measure "#{queue_namespace}.memory.delta", memory_delta_in_bytes
          client.measure "#{queue_namespace}.gc.count", total_gc_count
        end
      end

      # returns number of bytes used by current process
      def memory_snapshot
        Oink::Instrumentation::MemorySnapshot.memory
      end
    end
  end
end
