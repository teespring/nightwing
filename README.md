# Nightwing

Nightwing is a Sidekiq middleware for capturing worker metrics including number processed, number of failures, timing, etc.

## Installation

Inside your Gemfile, add the following line:

```Gemfile
gem 'nightwing', github: 'teespring/nightwing'
```

## Configuration

You will need to add the code below to your app. In a typical Rails app, this would go into an initializer.

```ruby
# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Nightwing::Sidekiq::Stats, client: Librato
    chain.add Nightwing::Sidekiq::QueueStats, client: Librato
    chain.add Nightwing::Sidekiq::WorkerStats, client: Librato
  end
end
```

### Available options

- `client`: Librato or statsd client. Required.
- `namespace`: the string each metric is prefixed with. Defaults to `"sidekiq"`.

## Metrics

Below are the metrics reported to Librato from the Sidekiq middleware

- `sidekiq.retries`: number of jobs to be retried
- `sidekiq.scheduled`: number of jobs scheduled to run
- `sidekiq.processed`: number of times middleware called
- `sidekiq.failed`: number of jobs that raised an error

### Queue specific

- `sidekiq.<queue>.size`: depth for a given queue
- `sidekiq.<queue>.latency`: latency for given queue¹
- `sidekiq.<queue>.processed`: number of times middleware called for given queue
- `sidekiq.<queue>.failed`: number of jobs in given queue that raised an error

¹: the difference between now and when the oldest job was enqueued (given in seconds)

### Worker specific

- `sidekiq.<queue>.<worker>.processed`: number of times middleware called for given worker
- `sidekiq.<queue>.<worker>.failed`: number of jobs in given worker that raised an error
- `sidekiq.<queue>.<worker>.finished`: number of successful worker jobs
