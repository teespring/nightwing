require "sidekiq/api"
require "nightwing/metric"
require "nightwing/debug_client"
require "nightwing/logger"
require "nightwing/client_logger"

module Nightwing
  module Sidekiq
    class Base
      attr_reader :namespace, :logger

      def initialize(options = {})
        @namespace = options.fetch(:namespace, "sidekiq")
        @client = options.fetch(:client, Nightwing::DebugClient.new)
        @logger = options.fetch(:logger, Nightwing::Logger.new)
        @debug = options.fetch(:debug, false)
      end

      def client
        @client_proxy ||= begin
          if @debug
            Nightwing::ClientLogger.new(client: @client, logger: @logger)
          else
            @client
          end
        end
      end

      private

      def metrics
        @_metrics ||= Nightwing::Metric.new(namespace)
      end
    end
  end
end
