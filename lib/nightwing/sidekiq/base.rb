require "sidekiq/api"
require "nightwing/metric"
require "nightwing/debug_client"

module Nightwing
  module Sidekiq
    class Base
      attr_reader :namespace, :client

      def initialize(options = {})
        @namespace = options.fetch(:namespace, "sidekiq")
        @client = options.fetch(:client, Nightwing::DebugClient.new)
      end

      private

      def metrics
        @_metrics ||= Nightwing::Metric.new(namespace)
      end
    end
  end
end
