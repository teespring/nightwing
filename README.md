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
- `robin.sidekiq.enqueued`: number of jobs enqueued since last report
- `robin.sidekiq.processed`: number of jobs processed since last report
- `robin.sidekiq.failed`: number of jobs failed since last report

### Queue specific

- `robin.sidekiq.<queue>.size`: depth for a given queue
- `robin.sidekiq.<queue>.latency`: latency for given queue¹

### Robin specific

- `robin.sidekiq.measured`: number of times middleware was called
- `robin.sidekiq.failed`: number of failures caused by middleware

## Additional resources

¹: the difference between now and when the oldest job was enqueued (given in seconds)
