require "librato-rack"
require "sidekiq/api"
require "robin/metric"
require "robin/nil_client"

module Robin
  module Sidekiq
    class Base
      attr_reader :namespace, :client

      def initialize(options = {})
        @namespace = options.fetch(:namespace, "sidekiq")
        @client = options.fetch(:client, Robin::NilClient.new)
      end

      private

      def metrics
        @_metrics ||= Robin::Metric.new(namespace)
      end
    end
  end
end
