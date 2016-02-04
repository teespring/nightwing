module Nightwing
  class ClientLogger
    def initialize(client:, logger:)
      @client = client
      @logger = logger
    end

    def method_missing(method, *args, &block)
      unless @client.respond_to?(method)
        super
      end

      @logger.info "method=#{method} metric=#{args[0]} value=#{args.last if args.size > 1}"
      @client.public_send(method, *args)
    end
  end
end
