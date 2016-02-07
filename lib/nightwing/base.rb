require "nightwing/metric"
require "nightwing/debug_client"
require "nightwing/logger"
require "nightwing/client_logger"

module Nightwing
  class Base
    attr_reader :namespace, :logger

    def initialize(options = {})
      @namespace = options.fetch(:namespace)
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
  end
end
