## Unreleased

- Add new Profiler middleware
- Add a copy of the MIT license

**New Metrics**

- `sidekiq.<queue>.<worker>.time`
- `sidekiq.<queue>.time`
- `sidekiq.<queue>.<worker>.retried`

## 0.0.5

- Renamed project to "Nightwing"

## 0.0.4

- Changed default namespace from "robin.sidekiq" to "sidekiq"
- Removed Librato dependency
- `:client` middleware option is now required
