# Nightwing [![Gem Version](https://badge.fury.io/rb/nightwing.svg)](https://badge.fury.io/rb/nightwing)

Nightwing is a Sidekiq middleware for capturing worker metrics including number processed, number of failures, timing, etc.

## Installation

Inside your Gemfile, add the following line:

```Gemfile
gem 'nightwing'
```

## Configuration

You will need to add the code below to your app. In a typical Rails app, this would go into an initializer.

Please note that you must require your own librato-rack gem and supply it to Nightwing

```ruby
# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Nightwing::Sidekiq::Stats, client: Librato
    chain.add Nightwing::Sidekiq::QueueStats, client: Librato
    chain.add Nightwing::Sidekiq::WorkerStats, client: Librato
    chain.add Nightwing::Sidekiq::Profiler, client: Librato
  end
end
```

To gather database metrics:

```ruby
# config/initializers/instrumentation.rb
Nightwing.client = Librato

ActiveSupport::Notifications.subscribe('sql.active_record', Nightwing::Instrumentation::ActiveRecord.new)
```

To gather Redis and memcache metrics:

```ruby
# config/initializers/instrumentation.rb
Nightwing.client = Librato

require 'nightwing/extensions/dalli' # dalli gem required
require 'nightwing/extensions/redis' # redis gem required
```


### Available options

| Name      | Description                    | Required? | Default           |
|-----------|--------------------------------|-----------|-------------------|
| client    | Librato or statsd client       | yes       | N/A               |
| namespace | Prefix for each metric         | no        | "sidekiq"         |
| debug     | Enable for verbose logging     | no        | false             |
| logger    | Logger instance for debug mode | no        | Nightwing::Logger |

When debug mode is turned on, Nightwing will output the metrics into a parsable format. The output destination is determined by the logger. If no logger is given then we send the debugging output to STDOUT.

## Instrumentation Metrics

Below are the metrics reported to Librato from instrumentation classes

- `sql.<table>.<action>.time`: how long the database query took to complete

## Extensions Metrics

Below are the metrics reported to Librato from instrumentation classes

- `redis.command.processed`: number of times overall command was called
- `redis.command.time`: response time (in ms) for all commands
- `redis.command.<command>.processed`: number of times the command was called
- `redis.command.<command>.time`: response time (in ms) for command
- `memcache.command.processed`: number of times overall command was called
- `memcache.command.time`: response time (in ms) for all commands
- `memcache.command.<command>.processed`: number of times the command was called
- `memcache.command.<command>.time`: response time (in ms) for command

## Sidekiq Metrics

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
- `sidekiq.<queue>.time`: how long jobs took to process (in milliseconds)
- `sidekiq.<queue>.gc.count`: number of times the Ruby GC kicked off
- `sidekiq.<queue>.memory.delta`: the different in the process memory after jobs were processed (in bytes)

¹: the difference between now and when the oldest job was enqueued (given in seconds)

### Worker specific

- `sidekiq.<queue>.<worker>.processed`: number of times middleware called for given worker
- `sidekiq.<queue>.<worker>.failed`: number of jobs in given worker that raised an error
- `sidekiq.<queue>.<worker>.finished`: number of successful worker jobs
- `sidekiq.<queue>.<worker>.time`: how long given worker took to process (in milliseconds)
- `sidekiq.<queue>.<worker>.retried`: number of times a given worker retried
- `sidekiq.<queue>.<worker>.gc.count`: number of times the Ruby GC kicked off
- `sidekiq.<queue>.<worker>.memory.delta`: the different in the process memory after jobs were processed (in bytes)
