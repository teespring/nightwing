require "nightwing/base"

module Nightwing
  module Instrumentation
    class Base < Nightwing::Base
      def initialize(options = {})
        super default_options.merge(options)
      end

      private

      def default_options
        { namespace: "instrumentation" }
      end
    end
  end
end
