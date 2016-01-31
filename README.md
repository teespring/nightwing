# Robin

Sidekiq metrics gathering middleware

## Installation

Inside your Gemfile, add the following line:

```Gemfile
gem 'robin', github: 'teespring/robin'
```

This will add the gem as a runtime dependency. Robin automatically loads its server middleware into Sidekiq.

## Configuration

You will need to add the code below to your app. In a typical Rails app, this would go into an initializer.

```ruby
# config/initializers/robin.rb
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Robin::Sidekiq::QueueStats, namespace: 'mycompany.sidekiq'
  end
end
```

### Available options

- `namespace`: the string each metric is prefixed with. Defaults to `robin.sidekiq`.

## Metrics

Below are the metrics reported to Librato from the Sidekiq middleware

- `robin.sidekiq.retries`: number of jobs to be retried
- `robin.sidekiq.scheduled`: number of jobs scheduled to run
- `robin.sidekiq.processed`: number of times middleware called
- `robin.sidekiq.failed`: number of jobs that raised an error

### Queue specific

- `robin.sidekiq.<queue>.size`: depth for a given queue
- `robin.sidekiq.<queue>.latency`: latency for given queue¹
- `robin.sidekiq.<queue>.processed`: number of times middleware called for given queue
- `robin.sidekiq.<queue>.failed`: number of jobs in given queue that raised an error

¹: the difference between now and when the oldest job was enqueued (given in seconds)

### Worker specific

- `robin.sidekiq.<queue>.<worker>.processed`: number of times middleware called for given worker
- `robin.sidekiq.<queue>.<worker>.failed`: number of jobs in given worker that raised an error
- `robin.sidekiq.<queue>.<worker>.finished`: number of successful worker jobs
