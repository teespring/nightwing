require "nightwing/version"
require "nightwing/debug_client"
require "nightwing/instrumentation/active_record"
require "nightwing/sidekiq/base"
require "nightwing/sidekiq/stats"
require "nightwing/sidekiq/queue_stats"
require "nightwing/sidekiq/worker_stats"
require "nightwing/sidekiq/profiler"

module Nightwing
  extend self

  def client
    @client || internal_client
  end

  def client=(c)
    @client = c
  end

  private

  def internal_client
    @internal_client ||= Nightwing::DebugClient.new
  end
end
