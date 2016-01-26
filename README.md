# Robin

Sidekiq metrics gathering middleware

## Installation

Inside your Gemfile

```Gemfile
gem 'robin', github: 'teespring/robin'
```

The middleware will get added Sidekiq's middleware chain. It happens automatically when the gem gets loaded.

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
