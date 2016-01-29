require "active_support/core_ext/string"

module Robin
  module Sidekiq
    ##
    # Metric is used to generate metric names
    class Metric
      attr_reader :namespace

      def initialize(namespace)
        @namespace = namespace
      end

      ##
      # Generates a metric name
      #
      # @param [String] queue
      # @param [Class]  worker
      #
      # returns a String object
      def for(queue:, worker: nil)
        worker_name = worker.to_s.underscore.tr("/", "_") if worker
        [namespace, queue, worker_name].compact.join(".")
      end
    end
  end
end
