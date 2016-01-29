module Robin
  module Sidekiq
    class Base
      attr_reader :namespace

      def initialize(options = {})
        @namespace = options.fetch(:namespace, "robin.sidekiq")
      end

      private

      def metrics
        @_metrics ||= Metric.new(namespace)
      end
    end
  end
end
