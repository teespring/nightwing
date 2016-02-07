require "sidekiq/api"
require "nightwing/base"

module Nightwing
  module Sidekiq
    class Base < Nightwing::Base
      def initialize(options = {})
        super options.merge(namespace: "sidekiq")
      end

      private

      def metrics
        @_metrics ||= Nightwing::Metric.new(namespace)
      end
    end
  end
end
