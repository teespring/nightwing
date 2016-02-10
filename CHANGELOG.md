## 0.2.0

- Renamed memory_used metric so that we can utilize the memory namespace for additional metrics

**Renamed Metrics**

- `sidekiq.<queue>.<worker>.memory_used` to `sidekiq.<queue>.<worker>.memory.delta`

## 0.1.0

- Add new Profiler middleware
- Add a copy of the MIT license
- New debug mode
- Allow users to pass in their own logger object

**New Metrics**

In `Nightwing::Sidekiq::Profiler` middleware:

- `sidekiq.<queue>.<worker>.retried`

In `Nightwing::Sidekiq::Profiler` middleware:

- `sidekiq.<queue>.time`
- `sidekiq.<queue>.memory_used`
- `sidekiq.<queue>.gc.count`
- `sidekiq.<queue>.<worker>.time`
- `sidekiq.<queue>.<worker>.gc.count`
- `sidekiq.<queue>.<worker>.memory_used`

## 0.0.5

- Renamed project to "Nightwing"

## 0.0.4

- Changed default namespace from "robin.sidekiq" to "sidekiq"
- Removed Librato dependency
- `:client` middleware option is now required
