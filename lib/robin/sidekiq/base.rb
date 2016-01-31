require "librato-rack"
require "sidekiq"
require "robin/metric"

module Robin
  module Sidekiq
    class Base
      attr_reader :namespace, :client

      def initialize(options = {})
        @namespace = options.fetch(:namespace, "robin.sidekiq")
        @client = options.fetch(:client, Librato)
      end

      private

      def metrics
        @_metrics ||= Robin::Metric.new(namespace)
      end
    end
  end
end
