require 'robin/version'
require 'robin/sidekiq/queue_stats'
require 'sidekiq'

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Robin::Sidekiq::QueueStats, namespace: 'robin.sidekiq'
  end
end
