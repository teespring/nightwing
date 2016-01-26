require 'robin/version'
require 'robin/sidekiq/middleware'
require 'sidekiq'

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Robin::Sidekiq::Middleware, namespace: 'robin.sidekiq'
  end
end
